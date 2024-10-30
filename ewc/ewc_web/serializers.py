from rest_framework import serializers
from .models import UserProfile, CollectionPoint, JourneyMetric, WastePrediction

# Serializer for UserProfile model
class UserProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserProfile
        fields = '__all__'  # Serialize all fields in the UserProfile model

# Serializer for CollectionPoint model
class CollectionPointSerializer(serializers.ModelSerializer):
    class Meta:
        model = CollectionPoint
        fields = '__all__'  # Serialize all fields in the CollectionPoint model

# Serializer for JourneyMetric model
class JourneyMetricSerializer(serializers.ModelSerializer):
    class Meta:
        model = JourneyMetric
        fields = '__all__'  # Serialize all fields in the JourneyMetric model

# Serializer for WastePrediction model
class WastePredictionSerializer(serializers.ModelSerializer):
    class Meta:
        model = WastePrediction
        fields = '__all__'  # Serialize all fields in the WastePrediction model