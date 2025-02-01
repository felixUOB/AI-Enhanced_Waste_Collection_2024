from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from django.contrib.auth.models import User
from .models import UserProfile, Stops, StopCollection, RouteEnvData

class UserRegistrationTest(APITestCase):
    """
    Tests for the user registration endpoint.
    This test checks that a new user and their associated UserProfile
    are properly created when posting valid data to the registration endpoint.
    """
    def test_user_registration(self):
        # Reverse lookup of the registration endpoint URL by its name
        url = reverse('user-registration')
        payload = {
            "username": "testuser",
            "password": "testpass123",
            "email": "test@example.com",
            "phone_number": "01012345678",
            "address": "UK, Bristol",
            "pickup_frequency": "weekly",
            "waste_type_preference": "general",
            "notification_preferences": True
        }
        response = self.client.post(url, payload, format='json')
        # Expect HTTP 201 CREATED if registration is successful
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        # Verify that the User is created in the database
        self.assertTrue(User.objects.filter(username="testuser").exists())
        # Verify that a corresponding UserProfile is created for the user
        self.assertTrue(UserProfile.objects.filter(user__username="testuser").exists())