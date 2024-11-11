from django.shortcuts import render
from rest_framework import viewsets, permissions
from .models import UserProfile, CollectionPoint, JourneyMetric, WastePrediction
from .serializers import UserProfileSerializer, CollectionPointSerializer, JourneyMetricSerializer, WastePredictionSerializer

# Home view function
def home(request):
    return render(request, 'ewc_app/home.html')

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