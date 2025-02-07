from rest_framework import viewsets, permissions, generics
from rest_framework.views import APIView
from rest_framework.response import Response
from .models import UserProfile, StopCollection, Stops, RouteEnvData
from .serializers import UserProfileSerializer, StopCollectionSerializer, StopsSerializer, RouteEnvDataSerializer, UserRegistrationSerializer, UserSerializer
from django.contrib.auth.models import User
from django.http import JsonResponse
from django.contrib.auth import views as auth_views
from django.contrib.auth.views import PasswordResetCompleteView, PasswordResetView


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
    
