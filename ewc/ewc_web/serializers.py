from rest_framework import serializers
from django.contrib.auth.models import User
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

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ('id', 'email', 'password')

# Register set-up
class UserRegistrationSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    phone_number = serializers.CharField(write_only=True, required=False)
    address = serializers.CharField(write_only=True, required=False)
    pickup_frequency = serializers.ChoiceField(
        choices=[('weekly', 'Weekly'), ('biweekly', 'Biweekly'), ('monthly', 'Monthly')],
        default='weekly',
        write_only=True,
        required=False
    )
    waste_type_preference = serializers.ChoiceField(
        choices=[('general', 'General'), ('recycling', 'Recycling'), ('organic', 'Organic')],
        default='general',
        write_only=True,
        required=False
    )
    notification_preferences = serializers.BooleanField(default=True, write_only=True, required=False)

    class Meta:
        model = User
        fields = ('username', 'password', 'email', 'phone_number', 'address',
                  'pickup_frequency', 'waste_type_preference', 'notification_preferences')

    def create(self, validated_data):
        user_data = {
            'username': validated_data['username'],
            'email': validated_data.get('email', '')
        }
        password = validated_data.pop('password')
        user = User(**user_data)
        user.set_password(password)
        user.save()

        # UserProfile 생성
        UserProfile.objects.create(
            user=user,
            phone_number=validated_data.get('phone_number', ''),
            address=validated_data.get('address', ''),
            pickup_frequency=validated_data.get('pickup_frequency', 'weekly'),
            waste_type_preference=validated_data.get('waste_type_preference', 'general'),
            notification_preferences=validated_data.get('notification_preferences', True)
        )

        return user