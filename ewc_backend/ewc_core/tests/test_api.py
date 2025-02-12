from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from django.contrib.auth.models import User
from ewc_core.models import UserProfile, Stops, StopCollection, RouteEnvData
from datetime import date
# python manage.py test ewc_core.tests

# Overall Structure
#      - Each test class inherits from APITestCase (from Django REST framework),
#        which provides tools for testing API endpoints.
#      - The tests use Django’s test client to send requests to your API endpoints
#        and then compare the received responses with the expected outcomes.

class UserRegistrationTest(APITestCase):
    """
    UserRegistrationTest
      - Purpose: Verifies the "user-registration" endpoint.
      - Key steps:
          1. Constructs a payload with registration info (username, password, email, etc.).
          2. Sends a POST request to the endpoint (reverse('user-registration')).
          3. Checks for:
             • HTTP 201 CREATED.
             • A new User in the User model.
             • A corresponding UserProfile linked to that user.
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
    - Purpose: Tests the "check-email" endpoint under different scenarios.
      - Key scenarios:
          1. No email parameter: expects an error/failure response.
          2. Existing email: verifies the endpoint indicates the email exists.
          3. Non-existing email: verifies the endpoint indicates the email does not exist.
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
    UserProfileViewSetTest
      - Purpose: Ensures authenticated users can access the "UserProfile" endpoint.
      - Key steps:
          1. Creates and authenticates a test user (setUp()).
          2. Sends a GET request to reverse('userprofile-list').
          3. Expects a 200 OK response.
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

class StopsViewSetTest(APITestCase):
    """
    - Purpose: Validates that "Stops" endpoint returns a list of Stops objects.
      - Key steps:
          1. Creates and authenticates a test user (setUp()).
          2. Creates a sample Stops object in the DB.
          3. Sends a GET request to reverse('stops-list').
          4. Checks for 200 OK and at least one item in the returned list.
    """
    def setUp(self):
        # Create and authenticate a user for testing
        self.user = User.objects.create_user(username="stopsuser", password="pass123")
        self.client.force_authenticate(user=self.user)
        # Create a sample Stops object for testing GET requests
        self.stop = Stops.objects.create(
            location_name="Test Stop",
            latitude=37.5665,
            longitude=126.9780,
            next_collection_due_date=None,
            max_weight=100
        )

    def test_get_stops(self):
        # Reverse lookup of the Stops list endpoint
        url = reverse('stops-list')
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # Verify that at least one stop is returned
        self.assertGreaterEqual(len(response.data), 1)

class StopCollectionViewSetTest(APITestCase):
    """
    - Purpose: Confirms that "StopCollection" endpoint returns StopCollection objects.
      - Key steps:
          1. Creates and authenticates a test user (setUp()).
          2. Creates a Stops object and a related StopCollection object.
          3. Sends a GET request to reverse('stopcollection-list').
          4. Checks for 200 OK and at least one returned record.
    """
    def setUp(self):
        # Create and authenticate a user for testing
        self.user = User.objects.create_user(username="collectionuser", password="pass123")
        self.client.force_authenticate(user=self.user)
        # Create a sample Stops object
        self.stop = Stops.objects.create(
            location_name="Collection Stop",
            latitude=35.0,
            longitude=129.0,
            next_collection_due_date=None,
            max_weight=200
        )
        # Create a sample StopCollection object linked to the Stops object
        self.collection = StopCollection.objects.create(
            stop=self.stop,
            weight_collected=75,
            date=date.today()
        )

    def test_get_stop_collections(self):
        # Reverse lookup of the StopCollection list endpoint
        url = reverse('stopcollection-list')
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # Verify that at least one stop collection is returned
        self.assertGreaterEqual(len(response.data), 1)

class RouteEnvDataViewSetTest(APITestCase):
    """
    - Purpose: Validates retrieval of route environmental data via "RouteEnvData" endpoint.
      - Key steps:
          1. Creates and authenticates a test user (setUp()).
          2. Creates a RouteEnvData object in the DB.
          3. Sends a GET request to reverse('routeenvdata-list').
          4. Expects 200 OK and at least one record in response.
    """
    def setUp(self):
        # Create and authenticate a user for testing
        self.user = User.objects.create_user(username="routeenvuser", password="pass123")
        self.client.force_authenticate(user=self.user)
        # Create a sample RouteEnvData object for testing; note that the 'date' field is a FloatField
        self.route_data = RouteEnvData.objects.create(
            distance=150.0,
            mpg=30.0,
            date=date.today()  # Example numeric value since 'date' is defined as a FloatField
        )

    def test_get_route_env_data(self):
        # Reverse lookup of the RouteEnvData list endpoint
        url = reverse('routeenvdata-list')
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # Verify that at least one route environmental data entry is returned
        self.assertGreaterEqual(len(response.data), 1)