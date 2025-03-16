from rest_framework import viewsets, permissions, generics
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework.response import Response
import requests
from django.http import JsonResponse
from django.conf import settings

from .models import UserProfile, StopCollection, Stops, RouteEnvData
from .serializers import UserProfileSerializer, StopCollectionSerializer, StopsSerializer, RouteEnvDataSerializer, UserRegistrationSerializer, UserSerializer

from django.contrib.auth.models import User
from django.http import JsonResponse
from django.contrib.auth import views as auth_views
from django.contrib.auth.views import PasswordResetCompleteView, PasswordResetView
from django.shortcuts import render, get_object_or_404, redirect

from .forms import StopsForm
from .models import Stops
from django.contrib.auth.decorators import login_required, user_passes_test



from rest_framework.decorators import api_view
from rest_framework.response import Response

# User Profile ViewSet
class UserProfileViewSet(viewsets.ModelViewSet):
    queryset = UserProfile.objects.all()
    serializer_class = UserProfileSerializer
    permission_classes = [permissions.IsAuthenticated]  # Accessible only by authenticated users

# Collection Point ViewSet
class StopCollectionViewSet(viewsets.ModelViewSet):
    queryset = StopCollection.objects.all()
    serializer_class = StopCollectionSerializer
    permission_classes = [permissions.IsAuthenticated]  # Accessible only by authenticated users

# Journey Metric ViewSet
class RouteEnvDataViewSet(viewsets.ModelViewSet):
    queryset = RouteEnvData.objects.all()
    serializer_class = RouteEnvDataSerializer
    permission_classes = [permissions.IsAuthenticated]  # Accessible only by authenticated users

    def get_route_env_data(self, request):
        return Response({"message"})

# Waste Prediction ViewSet
class StopsViewSet(viewsets.ModelViewSet):
    queryset = Stops.objects.all()
    serializer_class = StopsSerializer
    permission_classes = [permissions.IsAuthenticated]  # Accessible only by authenticated users

# Registration view
class UserRegistrationView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = UserRegistrationSerializer
    permission_classes = [permissions.AllowAny]  # Accessible to anyone    

class CheckEmailView(APIView):
    permission_classes = [permissions.AllowAny]

    def get(self, request):
        email = request.query_params.get('email')
    

        if not email:
            return Response({'success': False, 'message': 'Email is required'})

        # Check if the email exists in the User model
        email_exists = User.objects.filter(email=email).exists()
        print(email)
        print(email_exists)
        # Return JSON response indicating whether the email exists
        return Response({'exists': email_exists})
    
def is_staff_user(user):
    return user.is_staff
# python manage.py createsuperuser

@login_required
@user_passes_test(is_staff_user)
def stops_list_view(request):
    """Admin/staff only: View that displays a list of Stops."""
    stops = Stops.objects.all()
    return render(request, 'stops/stops_list.html', {'stops': stops})

@login_required
@user_passes_test(is_staff_user)
def stops_create_view(request):
    """Admin/staff only: create a new Stops record."""
    if request.method == 'POST':
        form = StopsForm(request.POST)
        if form.is_valid():
            form.save()
            return redirect('stops_list')
    else:
        form = StopsForm()
    return render(request, 'stops/stops_form.html', {'form': form})

@login_required
@user_passes_test(is_staff_user)
def stops_delete_view(request, pk):
    """Admin/staff only: delete an existing Stop."""
    stop_obj = get_object_or_404(Stops, pk=pk)

    if request.method == 'POST':
        # deletion logic
        stop_obj.delete()
        return redirect('stops_list')

    # For GET requests: users may see ‘Are you sure you want to delete?’ confirmation page
    return render(request, 'stops/stops_confirm_delete.html', {'stop': stop_obj})

@login_required
@user_passes_test(is_staff_user)
def stops_edit_view(request, pk):
    """Admin/staff only: edit an existing Stops record."""
    stop_obj = get_object_or_404(Stops, pk=pk)
    if request.method == 'POST':
        form = StopsForm(request.POST, instance=stop_obj)
        if form.is_valid():
            form.save()
            return redirect('stops_list')
    else:
        form = StopsForm(instance=stop_obj)
    return render(request, 'stops/stops_form.html', {'form': form, 'stop': stop_obj})


@login_required
@user_passes_test(is_staff_user)
def get_coordinates_by_name(request):
    stop_name = request.GET.get('name')
    api_key = settings.OPENROUTESERVICE_API_KEY
    url = f'https://api.openrouteservice.org/geocode/search?api_key={api_key}&text={stop_name}'
    response = requests.get(url)
    data = response.json()

    if 'features' in data and len(data['features']) > 0:
        location = data['features'][0]['geometry']['coordinates']
        return JsonResponse({
            'latitude': location[1],
            'longitude': location[0],
            'location_name': ','.join(data.get('features')[0].get('properties').get('label').split(',')[:2]) if data.get('features')[0].get('properties').get('label') else ''
        })
    else:
        return JsonResponse({'error': 'Location not found'}, status=404)
    
@login_required
@user_passes_test(is_staff_user)
def get_stops_list(request):
    stops = Stops.objects.all()
    serializer = StopsSerializer(stops, many=True)
    return JsonResponse(serializer.data, safe=False)