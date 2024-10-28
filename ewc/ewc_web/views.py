from django.shortcuts import render, redirect
from rest_framework import viewsets
from .models import UserProfile, CollectionPoint, JourneyMetric, WastePrediction
from .serializers import UserProfileSerializer, CollectionPointSerializer, JourneyMetricSerializer, WastePredictionSerializer

def home(request):
    return render(request, 'ewc_app/home.html')

class UserProfileViewSet(viewsets.ModelViewSet):
    queryset = UserProfile.objects.all()
    serializer_class = UserProfileSerializer

class CollectionPointViewSet(viewsets.ModelViewSet):
    queryset = CollectionPoint.objects.all()
    serializer_class = CollectionPointSerializer

class JourneyMetricViewSet(viewsets.ModelViewSet):
    queryset = JourneyMetric.objects.all()
    serializer_class = JourneyMetricSerializer

class WastePredictionViewSet(viewsets.ModelViewSet):
    queryset = WastePrediction.objects.all()
    serializer_class = WastePredictionSerializer

