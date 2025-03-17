import 'dart:convert';
import 'package:ewc/screens/metrics/route_data.dart';
import 'package:ewc/service_locator.dart';
import 'package:ewc/services/auth_service/auth_service.dart';

/// A service class for handling route-related data.
/// Includes methods to fetch all existing routes from the server
/// and send new route data (distance, MPG, date) when a journey finishes.

/// This file manages the metrics service and provides functionality to fetch
///
/// Functions:
/// - `fetchAllRoutes()`: Fetches all the routes from the backend.

class MetricsService {

  /// Fetches all route records from the server.
  ///
  /// - Uses `makeAuthenticatedRequest` to ensure the request is sent
  ///   with a valid JWT token.
  /// - If the response is successful (status code 200), it parses
  ///   the returned JSON into a list of `JourneyRoute` objects.
  /// - Throws an [Exception] if the request fails or the response
  ///   contains an error status code.
  ///
  /// Returns a list of [JourneyRoute] instances on success.
  Future<List<JourneyRoute>> fetchAllRoutes() async {
    final response = await getIt<AuthService>()
        .makeAuthenticatedRequest('route_env_data/');

    if (response.statusCode == 200) {
      // Convert the response body to a List of JSON objects.
      final data = jsonDecode(response.body) as List;

      // Map each JSON object to a JourneyRoute instance.
      return data.map((route) => JourneyRoute(
        distance: route['distance'],
        mpg: route['mpg'],
        date: route['date'],
        filler: false,
      )).toList();
    } else {
      // If the server did not return a successful response,
      // throw an exception to indicate failure.
      throw Exception('Failed to load statistics data.');
    }
  }

  /// Sends new driving (route) data (distance, MPG, date) to the server.
  ///
  /// - Creates a JSON body containing the route data.
  /// - Calls `makeAuthenticatedPostRequest` to ensure the POST request
  ///   includes a valid JWT token in the header.
  /// - Upon a successful response (status code 201), prints a success message.
  /// - Otherwise, prints an error message and throws an Exception.
  Future<void> postRouteData({
    required double distance,
    required double mpg,
    required String date,
  }) async {
    // Prepare JSON body with distance, mpg, and date (e.g., "2023-12-05").
    final body = {
      'distance': distance,
      'mpg': mpg,
      'date': date,
    };

    // Make a POST request to the 'route_env_data/' endpoint,
    // passing the prepared body.
    final response = await getIt<AuthService>()
        .makeAuthenticatedPostRequest('route_env_data/', body);

    if (response.statusCode == 201) {
      print('Route data successfully saved in the DB!');
    } else {
      print('Failed to save route data. '
          'Status: ${response.statusCode}, Body: ${response.body}');
      throw Exception('POST error: ${response.body}');
    }
  }
}