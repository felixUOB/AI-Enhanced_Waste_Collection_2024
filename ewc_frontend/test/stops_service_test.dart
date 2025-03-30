import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ewc/services/stops_service.dart';
import 'package:ewc/services/auth_service/auth_service.dart';
import 'package:ewc/service_locator.dart';
import 'package:http/http.dart' as http;
import 'mocks/mock_auth_service.dart';

void main() {
  late StopsService stopsService; // Declares a variable for the service we're testing
  late MockAuthService mockAuthService; // Declares a mock object for AuthService

  setUp(() {
    // Creates a new mockAuthService before each test and registers it in the service locator
    mockAuthService = MockAuthService();
    getIt.registerSingleton<AuthService>(mockAuthService);

    // Initializes the real service under test
    stopsService = StopsService();
  });

  // Resets the service locator after each test to avoid affecting subsequent tests
  tearDown(() {
    getIt.reset();
  });

  group('StopsService.fetchStop', () {
    test('Returns LatLng on success', () async {
      // Creates a mock JSON response
      final mockResponse = http.Response(jsonEncode({
        'latitude': 51.0,
        'longitude': -2.0,
      }), 200);

      // When the mock AuthService is called with 'stops/123',
      // respond with the mock JSON
      when(mockAuthService.makeAuthenticatedRequest('stops/123'))
          .thenAnswer((_) async => mockResponse);

      // Calls the real method
      final result = await stopsService.fetchStop(123);

      // Verifies the method returns the correct coordinates
      expect(result.latitude, 51.0);
      expect(result.longitude, -2.0);
    });

    test('Throws an exception if status code is not 200', () async {
      // Creates a mock response with 404 status
      final mockResponse = http.Response('Not Found', 404);

      when(mockAuthService.makeAuthenticatedRequest('stops/123'))
          .thenAnswer((_) async => mockResponse);

      // Expects an exception when status is not 200
      expect(
            () => stopsService.fetchStop(123),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('StopsService.fetchAllStops', () {
      // test('Returns a list of Stop on success', () async {
      //   // Simulate mock data with next_collection_due_date included
      //   final mockData = [
      //     {
      //       'stop_id': 1,
      //       'location_name': 'Stop A',
      //       'latitude': 51.1,
      //       'longitude': -2.1,
      //       'next_collection_due_date': '2026-03-30T12:00:00Z', // Add a valid date
      //     },
      //     {
      //       'stop_id': 2,
      //       'location_name': 'Stop B',
      //       'latitude': 52.2,
      //       'longitude': -3.2,
      //       'next_collection_due_date': '2026-03-30T12:00:00Z', // Add a valid date
      //     }
      //   ];

      //   // Simulate the response with mock data
      //   final mockResponse = http.Response(jsonEncode(mockData), 200);

      //   // Mock the makeAuthenticatedRequest to return this response
      //   when(mockAuthService.makeAuthenticatedRequest('stops/'))
      //       .thenAnswer((_) async => mockResponse);

      //   // Call the service method
      //   final stops = await stopsService.fetchAllStops();

      //   // Check that both stops were returned
      //   expect(stops.length, 2);
      //   expect(stops.first.id, 1);
      //   expect(stops.first.name, 'Stop A');
      //   expect(stops.first.location.latitude, 51.1);
      // });

    test('Throws an exception if status code is not 200', () async {
      // Creates a mock response with 500 status
      final mockResponse = http.Response('Server Error', 500);

      when(mockAuthService.makeAuthenticatedRequest('stops/'))
          .thenAnswer((_) async => mockResponse);

      // Expects an exception for non-200 status
      expect(
            () => stopsService.fetchAllStops(),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('StopsService.postStopCollection', () {
    test('Completes without error when status is 201', () async {
      // Mocks a successful creation response
      final mockResponse = http.Response('Created', 201);

      // Sets the mock to return 201 for a POST request
      when(mockAuthService.makeAuthenticatedPostRequest(
        'stop_collection/',
        any,
      )).thenAnswer((_) async => mockResponse);

      // Calls the real postStopCollection method
      await stopsService.postStopCollection(1, 100);

      // Checks that the correct arguments were posted exactly once
      verify(mockAuthService.makeAuthenticatedPostRequest('stop_collection/', {
        'stop': 1,
        'weight_collected': 100
      })).called(1);
    });

    test('Throws an exception if status is not 201', () async {
      // Mocks a 400 Bad Request response
      final mockResponse = http.Response('Bad Request', 400);

      when(mockAuthService.makeAuthenticatedPostRequest(
        'stop_collection/',
        any,
      )).thenAnswer((_) async => mockResponse);

      // Expects an exception when status is not 201
      expect(
            () => stopsService.postStopCollection(2, 200),
        throwsA(isA<Exception>()),
      );
    });
  });
}
