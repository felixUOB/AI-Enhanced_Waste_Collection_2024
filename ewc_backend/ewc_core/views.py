from datetime import datetime, timedelta
from django.http import JsonResponse
from rest_framework import viewsets, permissions, generics
from rest_framework.response import Response
from rest_framework.decorators import action, api_view

import requests
from django.http import JsonResponse
from django.conf import settings
from .models import UserProfile, StopCollection, Stops, RouteEnvData, Depo
from .serializers import UserProfileSerializer, StopCollectionSerializer, StopsSerializer, RouteEnvDataSerializer, UserRegistrationSerializer, DepoSerializer
from django.contrib.auth.models import User
from django.shortcuts import render, get_object_or_404, redirect
from .forms import StopsForm
from django.contrib.auth.decorators import login_required, user_passes_test
from rest_framework import permissions
from drf_yasg.views import get_schema_view
from drf_yasg import openapi
from rest_framework.response import Response

"""
This file defines API views and web views for managing waste collection-related data  
using Django REST Framework (DRF) and Django's built-in authentication system.

API ViewSets:

1. UserProfileViewSet:
   - Manages user profile data.
   - Requires authentication.

2. StopCollectionViewSet:
   - Handles collection point records (waste collection at stops).
   - Requires authentication.

3. RouteEnvDataViewSet:
   - Provides access to environmental data related to waste collection routes.
   - Requires authentication.

4. StopsViewSet**:
   - Manages waste collection stops.
   - Requires authentication.

5. UserRegistrationView:
   - Allows user registration via API.
   - Open to all users (`permissions.AllowAny`).

   

Django Web Views:

1. stops_list_view(request):
   - Displays a list of stops for staff/admin users.
   - Requires login and staff/admin access.

2. stops_create_view(request):
   - Allows staff/admin users to create new waste collection stops.
   - Uses `StopsForm` for input validation.

3. stops_delete_view(request, pk):
   - Deletes an existing stop record.
   - Requires confirmation before deletion.

4. stops_edit_view(request, pk):
   - Allows staff/admin users to edit stop details.

Additional Features:

- API Schema Documentation:
  - Uses `drf-yasg` to generate API documentation (`schema_view`).
  - Provides OpenAPI documentation for the AI-Enhanced Waste Collection API.

- Permissions & Authentication:
  - Most views require authentication (`IsAuthenticated`).
  - Web views are restricted to staff/admin users.
"""


schema_view = get_schema_view(
    openapi.Info(
        title="AI-Enhanced Waste Collection API",
        default_version="v1",
        description="API documentation",
        license=openapi.License(name="Apache License"),
    ),
    public=True,
    permission_classes=[permissions.IsAuthenticated],
)

# User Profile ViewSet
class UserProfileViewSet(viewsets.ModelViewSet):
    '''
    API endpoint that allows user profiles to be viewed or edited.
    '''
    queryset = UserProfile.objects.all()
    serializer_class = UserProfileSerializer
    permission_classes = [permissions.IsAuthenticated]  # Accessible only by authenticated users

# Collection Point ViewSet
class StopCollectionViewSet(viewsets.ModelViewSet):
    '''
    API endpoint that allows collection points to be viewed or edited.'
    '''
    queryset = StopCollection.objects.all()
    serializer_class = StopCollectionSerializer
    permission_classes = [permissions.IsAuthenticated]  # Accessible only by authenticated users

# Journey Metric ViewSet
class RouteEnvDataViewSet(viewsets.ModelViewSet):
    '''
    API endpoint that allows journey metrics to be viewed or edited.
    '''
    queryset = RouteEnvData.objects.all()
    serializer_class = RouteEnvDataSerializer
    permission_classes = [permissions.IsAuthenticated]  # Accessible only by authenticated users

    @action(detail=False, methods=['get'])
    def get_route_env_data(self, request):
        data = list(RouteEnvData.objects.values('distance', 'mpg', 'date'))
        return JsonResponse(data, safe=False)

    @action(detail=False, methods=['get'])
    def get_route_env_data_30_days(self, request):
        end_time = datetime.now() - timedelta(days=30)
        routes = RouteEnvData.objects.filter(date__gte =end_time)
        data = list(routes.values('distance', 'mpg', 'date'))
        return JsonResponse(data, safe=False)

# Waste Prediction ViewSet
class StopsViewSet(viewsets.ModelViewSet):
    '''
    API endpoint that allows stops to be viewed or edited.
    '''
    queryset = Stops.objects.all()
    serializer_class = StopsSerializer
    permission_classes = [permissions.IsAuthenticated]  # Accessible only by authenticated users

# Registration view
class UserRegistrationView(generics.CreateAPIView):
    '''
    API endpoint that allows user registration.
    '''
    queryset = User.objects.all()
    serializer_class = UserRegistrationSerializer
    permission_classes = [permissions.AllowAny]  # Accessible to anyone  
    
def is_staff_user(user):
    """Check if the user is a staff member."""
    return user.is_staff

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

class DepoViewSet(viewsets.ModelViewSet):
    '''
    API endpoint that allows user profiles to be viewed or edited.
    '''
    queryset = Depo.objects.all()
    serializer_class = DepoSerializer
    permission_classes = [permissions.IsAuthenticated]  # Accessible only by authenticated users
    
    @action(detail=False, methods=['get'])
    def get_depo_location(self, request):
        data = list(Depo.objects.values('latitude', 'longitude'))
        return JsonResponse(data, safe=False)


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
        properties = data.get('features')[0].get('properties', {})
        label = properties.get('label', '')
        if label:
            parts = label.split(',')
            location_name = ','.join(parts[:2])
        else:
            location_name = ''

        return JsonResponse({
            'latitude': location[1],
            'longitude': location[0],
            'location_name': location_name
        })
    else:
        return JsonResponse({'error': 'Location not found'}, status=404)
    
@login_required
@user_passes_test(is_staff_user)
def reverse_geocode(request):
    latitude = request.GET.get('latitude')
    longitude = request.GET.get('longitude')
    api_key = settings.OPENROUTESERVICE_API_KEY
    url = f'https://api.openrouteservice.org/geocode/reverse?api_key={api_key}&point.lat={latitude}&point.lon={longitude}'
    response = requests.get(url)
    data = response.json()

    if data and data.get('features'):
        label = data['features'][0]['properties'].get('label', '')
        if label:
            parts = [p.strip() for p in label.split(',')]
            label = ', '.join(parts[:2])
        return JsonResponse({'location_name': label})
    else:
        return JsonResponse({'error': 'Reverse geocoding failed'}, status=404)
    
@login_required
@user_passes_test(is_staff_user)
def get_stops_list(request):
    stops = Stops.objects.all()
    serializer = StopsSerializer(stops, many=True)
    return JsonResponse(serializer.data, safe=False)
