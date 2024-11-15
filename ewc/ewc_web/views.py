from rest_framework import viewsets, permissions, generics
from .models import UserProfile, CollectionPoint, JourneyMetric, WastePrediction
from .serializers import UserProfileSerializer, CollectionPointSerializer, JourneyMetricSerializer, WastePredictionSerializer, UserRegistrationSerializer
from django.contrib.auth.models import User
from rest_framework.decorators import api_view
from rest_framework.response import Response

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

# Retrieves a given collection point record by its ID
@api_view(['GET'])
def get_collection_point(request,collection_point_id):
    try:
        collection_point = CollectionPoint.objects.get(id=collection_point_id)
        data = {
            'id': collection_point.id,
            'name': collection_point.location_name,
            'address': collection_point.address,
            'latitude': collection_point.latitude,
            'longitude': collection_point.longitude,
        }
        return Response(data)
    except CollectionPoint.DoesNotExist:
        return Response({'error: Collection Point does not exist'}, status=404)