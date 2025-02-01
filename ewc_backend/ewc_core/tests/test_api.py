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

class CheckEmailTest(APITestCase):
    """
    Tests for the email-check endpoint.
    These tests verify that the endpoint correctly handles cases
    where the email parameter is missing, exists, or does not exist.
    """
    def test_check_email_without_parameter(self):
        # Reverse lookup of the email-check endpoint URL
        url = reverse('check-email')
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # When no email is provided, the response should indicate failure
        self.assertFalse(response.data.get('success', True))
        self.assertIn('Email is required', response.data.get('message', ''))

    def test_check_email_existing(self):
        # Create a user with a known email for testing
        User.objects.create_user(username="existing", email="existing@example.com", password="pass")
        url = reverse('check-email')
        response = self.client.get(url, {'email': 'existing@example.com'})
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # The response should confirm that the email exists
        self.assertTrue(response.data.get('exists'))

    def test_check_email_non_existing(self):
        url = reverse('check-email')
        response = self.client.get(url, {'email': 'nonexistent@example.com'})
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # The response should confirm that the email does not exist
        self.assertFalse(response.data.get('exists'))

class UserProfileViewSetTest(APITestCase):
    """
    Tests for the UserProfile viewset.
    This viewset requires authentication, so a test user is created and authenticated.
    """
    def setUp(self):
        # Create a test user and force authentication for the test client
        self.user = User.objects.create_user(username="profileuser", password="pass123")
        self.client.force_authenticate(user=self.user)

    def test_get_user_profiles(self):
        # Reverse lookup of the UserProfile list endpoint (registered with basename 'userprofile')
        url = reverse('userprofile-list')
        response = self.client.get(url)
        # Expect HTTP 200 OK when accessing the user profiles list
        self.assertEqual(response.status_code, status.HTTP_200_OK)

