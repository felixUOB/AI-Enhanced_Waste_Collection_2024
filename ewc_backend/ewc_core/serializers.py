from rest_framework import serializers
from django.contrib.auth.models import User
from .models import UserProfile, StopCollection, Stops, RouteEnvData

"""
This file defines serializers for converting Django models into JSON format for API responses  
using Django REST Framework (DRF). It facilitates data exchange between the backend and frontend  
by serializing and deserializing model instances.

Serializers:

1. UserProfileSerializer:
   - Serializes all fields in the `UserProfile` model.
   - Handles user-related data including phone number, address, and waste management preferences.

2. StopCollectionSerializer:
   - Serializes all fields in the `StopCollection` model.
   - Represents waste collection events at various stops.

3. StopsSerializer:
   - Serializes all fields in the `Stops` model.
   - Provides location and scheduling data for waste collection points.

4. RouteEnvDataSerializer:
   - Serializes all fields in the `RouteEnvData` model.
   - Captures environmental impact data, such as distance traveled and fuel efficiency.

5. UserSerializer:
   - Serializes basic user information (`id`, `email`, `password`).

6. UserRegistrationSerializer:
   - Extends `UserSerializer` to handle user registration.
   - Accepts additional fields for phone number, address, pickup frequency, waste type preference,  
     and notification preferences.
   - Implements a `create()` method to generate new user accounts and associated `UserProfile` instances.
"""


# Serializer for UserProfile model
class UserProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserProfile
        fields = '__all__'  # Serialize all fields in the UserProfile model

# Serializer for CollectionPoint model
class StopCollectionSerializer(serializers.ModelSerializer):
    class Meta:
        model = StopCollection
        fields = '__all__'  # Serialize all fields in the CollectionPoint model

# Serializer for JourneyMetric model
class StopsSerializer(serializers.ModelSerializer):
    class Meta:
        model = Stops
        fields = '__all__'  # Serialize all fields in the JourneyMetric model

# Serializer for WastePrediction model
class RouteEnvDataSerializer(serializers.ModelSerializer):
    class Meta:
        model = RouteEnvData
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

    def create(self, request):
        user_data = {
            'username': request['username'],
            'email': request.get('email', '')
        }
        password = request.pop('password')
        user = User(**user_data)
        user.set_password(password)
        user.save()

        # UserProfile
        UserProfile.objects.create(
            user=user,
            phone_number=request.get('phone_number', ''),
            address=request.get('address', ''),
            pickup_frequency=request.get('pickup_frequency', 'weekly'),
            waste_type_preference=request.get('waste_type_preference', 'general'),
            notification_preferences=request.get('notification_preferences', True)
        )

        return user