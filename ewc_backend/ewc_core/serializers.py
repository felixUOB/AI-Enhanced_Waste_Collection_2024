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
   - Accepts additional fields for email address 
   - Implements a `create()` method to generate new user accounts and associated `UserProfile` instances.

7. DepoSerializer:
   - Serializes all fields in the 'Depo' model.
   - Represents the location of the depo.
"""


# Serializer for UserProfile model
class UserProfileSerializer(serializers.ModelSerializer):
    '''
    This serializer class converts the UserProfile model into JSON format for API responses.
    It includes all fields from the UserProfile model.
    '''
    class Meta:
        model = UserProfile
        fields = '__all__'  # Serialize all fields in the UserProfile model

# Serializer for CollectionPoint model
class StopCollectionSerializer(serializers.ModelSerializer):
    '''
    This serializer class converts the StopCollection model into JSON format for API responses.
    It includes all fields from the StopCollection model.
    '''
    class Meta:
        model = StopCollection
        fields = '__all__'  # Serialize all fields in the CollectionPoint model

# Serializer for JourneyMetric model
class StopsSerializer(serializers.ModelSerializer):
    '''
    This serializer class converts the Stops model into JSON format for API responses.
    It includes all fields from the Stops model.
    '''
    class Meta:
        model = Stops
        fields = '__all__'  # Serialize all fields in the JourneyMetric model

# Serializer for WastePrediction model
class RouteEnvDataSerializer(serializers.ModelSerializer):
    '''
    This serializer class converts the RouteEnvData model into JSON format for API responses.
    It includes all fields from the RouteEnvData model.
    '''
    class Meta:
        model = RouteEnvData
        fields = '__all__'  # Serialize all fields in the WastePrediction model

class UserSerializer(serializers.ModelSerializer):
    '''
    This serializer class converts the User model into JSON format for API responses.
    It includes basic user information such as id, email, and password.
    '''
    class Meta:
        model = User
        fields = ('id', 'email_address', 'password')

# Register set-up
class UserRegistrationSerializer(serializers.ModelSerializer):
    '''
    This serializer class extends the UserSerializer to handle user registration.
    It includes additional fields for email_address
    '''
    password = serializers.CharField(write_only=True)
    email_address = serializers.CharField(write_only=True, required=False)

    class Meta:
        model = User
        fields = ('username', 'password', 'email_address')

    def create(self, request):
        user_data = {
            'username': request['username'],
        }
        password = request.pop('password')
        user = User(**user_data)
        user.set_password(password)
        user.save()

        # UserProfile
        UserProfile.objects.create(
            user=user,
            email_address=request.get('email_address', ''),
        )

        return user
    
class DepoSerializer(serializers.ModelSerializer):
    '''
    This serializer class converts the Depo model into JSON format for API responses.
    It includes all fields from the Depo model.
    '''
    class Meta:
        model = RouteEnvData
        fields = '__all__'  # Serialize all fields in the WastePrediction model