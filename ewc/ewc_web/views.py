from rest_framework import viewsets, permissions, generics
from rest_framework.views import APIView
from rest_framework.response import Response
from .models import UserProfile, CollectionPoint, JourneyMetric, WastePrediction
from .serializers import UserProfileSerializer, CollectionPointSerializer, JourneyMetricSerializer, WastePredictionSerializer, UserRegistrationSerializer, UserSerializer
from django.contrib.auth.models import User
from django.http import JsonResponse


# User Profile ViewSet
class UserProfileViewSet(viewsets.ModelViewSet):
    queryset = UserProfile.objects.all()
    serializer_class = UserProfileSerializer
    permission_classes = [permissions.IsAuthenticated]  # Accessible only by authenticated users

# Collection Point ViewSet
class CollectionPointViewSet(viewsets.ModelViewSet):
    queryset = CollectionPoint.objects.all()
    serializer_class = CollectionPointSerializer
    permission_classes = [permissions.IsAuthenticated]  # Accessible only by authenticated users

# Journey Metric ViewSet
class JourneyMetricViewSet(viewsets.ModelViewSet):
    queryset = JourneyMetric.objects.all()
    serializer_class = JourneyMetricSerializer
    permission_classes = [permissions.IsAuthenticated]  # Accessible only by authenticated users

# Waste Prediction ViewSet
class WastePredictionViewSet(viewsets.ModelViewSet):
    queryset = WastePrediction.objects.all()
    serializer_class = WastePredictionSerializer
    permission_classes = [permissions.IsAuthenticated]  # Accessible only by authenticated users

# Registration view
class UserRegistrationView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = UserRegistrationSerializer
    permission_classes = [permissions.AllowAny]  # Accessible to anyone    

class UserListView(generics.ListAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [permissions.IsAdminUser]

class CheckEmailView(APIView):
    permission_classes = [permissions.AllowAny]

    def get(self, request):
        email = request.query_params.get('email')
    

        if not email:
            return Response({'success': False, 'message': 'Email is required'}, status=status.HTTP_400_BAD_REQUEST)

        # Check if the email exists in the User model
        email_exists = User.objects.filter(email=email).exists()
        print(email)
        print(email_exists)
        # Return JSON response indicating whether the email exists
        return Response({'exists': email_exists})