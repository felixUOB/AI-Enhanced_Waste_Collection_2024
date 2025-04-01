from django.urls import reverse
from rest_framework import status
from rest_framework.test import APITestCase
from django.contrib.auth.models import User
from ewc_core.models import UserProfile, Stops, StopCollection, RouteEnvData, Stops, Depot
from datetime import date
from unittest.mock import patch
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
            "email_address": "test@example.com",
        }
        response = self.client.post(url, payload, format='json')
        # Expect HTTP 201 CREATED if registration is successful
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)
        # Verify that the User is created in the database
        self.assertTrue(User.objects.filter(username="testuser").exists())
        # Verify that a corresponding UserProfile is created for the user
        self.assertTrue(UserProfile.objects.filter(user__username="testuser").exists())

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

class GetStopsListTest(APITestCase):
    """
    Test the get_stops_list view which returns all Stops as JSON.
    """
    def setUp(self):
        # Create a staff user and authenticate
        self.user = User.objects.create_user(username="user2", password="pass123", is_staff=True)
        self.client.force_login(user=self.user)
        # Create a sample Stop used for testing
        self.stop = Stops.objects.create(
            location_name="Test Stop",
            latitude=1.0,
            longitude=2.0,
            next_collection_due_date=None,
            max_weight=50
        )

    def test_get_stops_list(self):
        # Reverse lookup
        url = reverse('get_stops_list')
        response = self.client.get(url)
        self.assertEqual(response.status_code, 200)
        # Checks that a list is returned and contains the test stop
        data = response.json()
        self.assertIsInstance(data, list)
        self.assertGreaterEqual(len(data), 1)
        self.assertIn(self.stop.location_name, [stop.get("location_name") for stop in data])

class GetCoordinatesByNameTest(APITestCase):
    """
    Tests the get_coordinates_by_name view which retrieves coordinates through ORS API.
    """
    def setUp(self):
        # Create a staff user and authenticate
        self.user = User.objects.create_user(username="staffuser", password="pass123", is_staff=True)
        self.client.force_login(user=self.user)

    @patch('ewc_core.views.requests.get')
    def test_get_coordinates_by_name_success(self, mock_get):
        # Prepare a mocked API response from OpenRouteService
        mock_api_response = {
            "features": [
            {
                "geometry": {"coordinates": [-2.5879, 51.4492]},
                "properties": {"label": "Temple Meads, Bristol, United Kingdom"}
            }
            ]
        }
        # Configured the mocked requests.get to return fake API response
        mock_get.return_value.json.return_value = mock_api_response

        url = reverse('get_coordinates_by_name')
        response = self.client.get(url, {'name': 'Test Stop'})
        self.assertEqual(response.status_code, 200)
        data = response.json()
        self.assertEqual(data.get('latitude'), 51.4492)
        self.assertEqual(data.get('longitude'), -2.5879)
        # View should extract the first two comma separated parts of the label
        self.assertEqual(data.get('location_name'), 'Temple Meads, Bristol')

    @patch('ewc_core.views.requests.get')
    def test_get_coordinates_by_name_not_found(self, mock_get):
        # Simulate a response with no features found
        mock_api_response = {"features": []}
        mock_get.return_value.json.return_value = mock_api_response

        url = reverse('get_coordinates_by_name')
        response = self.client.get(url, {'name': 'Nonexistent Stop'})
        self.assertEqual(response.status_code, 404)
        data = response.json()
        self.assertIn('error', data)


class ReverseGeocodeTest(APITestCase):
    """
    Tests the reverse_geocode view which retrieves a location name given latitude and longitude values.
    """
    def setUp(self):
        # Create and authenticate a staff user
        self.user = User.objects.create_user(username="geouser", password="pass123", is_staff=True)
        self.client.force_login(user=self.user)

    @patch('ewc_core.views.requests.get')
    def test_reverse_geocode_success(self, mock_get):
        # Mocked API response from the reverse geocoding service
        mock_api_response = {
            "features": [
                {
                    "properties": {"label": "Test Location, City, Country"}
                }
            ]
        }
        # Configured the mocked requests.get to return the fake API response
        mock_get.return_value.json.return_value = mock_api_response

        url = reverse('reverse_geocode')
        response = self.client.get(url, {'latitude': 51.4492, 'longitude': -2.5879})
        self.assertEqual(response.status_code, 200)
        data = response.json()
        # View should extract the first two comma separated parts of the label
        self.assertEqual(data.get('location_name'), "Test Location, City")

    @patch('ewc_core.views.requests.get')
    def test_reverse_geocode_not_found(self, mock_get):
        # Simulate a response with no features
        mock_api_response = {"features": []}
        mock_get.return_value.json.return_value = mock_api_response

        url = reverse('reverse_geocode')
        response = self.client.get(url, {'latitude': 0, 'longitude': 0})
        self.assertEqual(response.status_code, 404)
        data = response.json()
        self.assertIn("error", data)


class ExportCSVViewTest(APITestCase):
    """
    Tests the export_csv_view which exports data as a CSV file (or PDF for environmentalreport).
    """
    def setUp(self):
        # Create and authenticate a staff user.
        self.user = User.objects.create_user(username="staffuser", password="pass123", is_staff=True)
        self.client.force_login(user=self.user)
        # Create a RouteEnvData object for CSV export -for option: 'route_env_data'
        self.route_data = RouteEnvData.objects.create(
            distance=150.0,
            mpg=30.0,
            date=date.today()
        )
        # Create a Stop and StopCollection object for CSV export -for option: 'stop_collections_data'
        self.stop = Stops.objects.create(
            location_name="Test Stop",
            latitude=1.0,
            longitude=2.0,
            next_collection_due_date=None,
            max_weight=100
        )
        self.stop_collection = StopCollection.objects.create(
            stop=self.stop,
            weight_collected=25,
            date=date.today()
        )

    def test_export_csv_view_no_table(self):
        """
        Should return an error 400 when there was no parameter provided.
        """
        url = reverse('export_csv')
        response = self.client.get(url)
        self.assertEqual(response.status_code, 400)

    def test_export_csv_view_routeenvdata(self):
        """
        Exports RouteEnvData as a CSV file format and verifies the headers and that there is at least 1 row of data - test obj.
        """
        url = reverse('export_csv')
        response = self.client.get(url, {'table': 'route_env_data'})
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response['Content-Type'], 'text/csv')
        content = response.content.decode('utf-8')
        self.assertIn("Date,Distance,MPG", content)
        self.assertIn(date.today().strftime("%Y-%m-%d"), content)
        self.assertIn("150.0", content)
        self.assertIn("30.0", content)

    def test_export_csv_view_stopdata(self):
        """
        Exports StopCollection data as a CSV file format and verifies the headers and that there is 1 row of data - test obj.
        """
        url = reverse('export_csv')
        response = self.client.get(url, {'table': 'stop_collections_data'})
        self.assertEqual(response.status_code, 200)
        self.assertEqual(response['Content-Type'], 'text/csv')
        content = response.content.decode('utf-8')
        self.assertIn("Date,Weight Collected", content)
        self.assertIn(date.today().strftime("%Y-%m-%d"), content)
        self.assertIn("25", content)

    def test_export_csv_view_invalid_option(self):
        """
        Invalid parameter option should give error 400.
        """
        url = reverse('export_csv')
        response = self.client.get(url, {'table': 'invalid'})
        self.assertEqual(response.status_code, 400)

class EditDepotViewTest(APITestCase):
    """
    Tests for the edit_depot view which allows staff to edit depot information.
    """
    def setUp(self):
        # Create and authenticate a staff user.
        self.staff_user = User.objects.create_user(username="depotuser", password="pass123", is_staff=True)
        self.client.force_login(self.staff_user)

        # Ensure a Depot instance exists - singelton logic.
        self.depot = Depot.load()
        self.depot.nickname = "Initial Depot"
        self.depot.latitude = 10.0
        self.depot.longitude = 20.0
        self.depot.save()

    def test_get_edit_depot(self):
        """
        GET request should render the depot edit form with saved data.
        """
        url = reverse('edit_depot')
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn("Initial Depot", response.content.decode('utf-8'))

    def test_post_edit_depot_valid(self):
        """
        A valid POST should update the depot and redirect to the stops list page.
        """
        url = reverse('edit_depot')
        data = {
            'nickname': 'Updated Depot',
            'latitude': 30.0,
            'longitude': 40.0,
        }
        response = self.client.post(url, data)
        self.assertEqual(response.status_code, status.HTTP_302_FOUND)
        self.assertRedirects(response, reverse('stops_list'))
        self.depot.refresh_from_db()
        self.assertEqual(self.depot.nickname, 'Updated Depot')
        self.assertEqual(self.depot.latitude, 30.0)
        self.assertEqual(self.depot.longitude, 40.0)

    def test_post_edit_depot_invalid(self):
        """
        Invalid POST should re render the form with errors.
        """
        url = reverse('edit_depot')
        data = {
            # Invalid latitude.
            'nickname': '',
            'latitude': 'invalid',
            'longitude': 40.0,
        }
        response = self.client.post(url, data)
        # Expect status 200 since the form should re render.
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        content = response.content.decode('utf-8')
        self.assertIn("Enter a number", content)