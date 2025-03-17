import 'dart:convert';
import 'package:ewc/screens/metrics/route_data.dart';
import 'package:ewc/service_locator.dart';
import 'package:ewc/services/auth_service/auth_service.dart';

/// This file manages the metrics service and provides functionality to fetch
///
/// Functions:
/// - `fetchAllRoutes()`: Fetches all the routes from the backend.

class MetricsService {
  Future<List<JourneyRoute>> fetchAllRoutes() async {
    final response =
        await getIt<AuthService>().makeAuthenticatedRequest('route_env_data/');
    // if the request is successful
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      List<JourneyRoute> routeList = [];
      for (var route in data) {
        routeList.add(JourneyRoute(
            distance: route['distance'],
            mpg: route['mpg'],
            date: route['date'],
            filler: false));
      }
      return routeList;
      // distance, mpg, date
    } else {
      throw Exception('Failed to load statistics data.');
    }
  }
}
