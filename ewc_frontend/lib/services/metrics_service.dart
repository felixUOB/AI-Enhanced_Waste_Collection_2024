import 'dart:convert';
import 'package:ewc/screens/metrics/route_data.dart';
import 'package:ewc/service_locator.dart';
import 'package:ewc/services/auth_service/auth_service.dart';


class MetricsService {
  Future<List<JourneyRoute>> fetchAllRoutes() async {
    final response = await getIt<AuthService>().makeAuthenticatedRequest('route_env_data/');
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      return data.map((route) => JourneyRoute(
        distance: route['distance'],
        mpg: route['mpg'],
        date: route['date'],
        filler: false
      )).toList();
    } else {
      throw Exception('Failed to load statistics data.');
    }
  }

    /// Sending driving data to a server by POST
  Future<void> postRouteData({
    required double distance,
    required double mpg,
    required String date,
  }) async {
    final body = {
      'distance': distance,
      'mpg': mpg,
      'date': date, // YYYY-MM-DD (ex: "2023-12-05")
    };

    /// Send a request with a JWT token via AuthService
    final response = await getIt<AuthService>().makeAuthenticatedPostRequest(
      'route_env_data/',
      body,
    );

    if (response.statusCode == 201) {
      print('Route data successfully saved in the DB!');
    } else {
      print('Failed to save route data. Status: ${response.statusCode}, Body: ${response.body}');
      throw Exception('POST error: ${response.body}');
    }
  }
}
