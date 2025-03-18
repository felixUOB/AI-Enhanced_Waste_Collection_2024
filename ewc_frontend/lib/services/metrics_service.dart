import 'dart:convert';
import 'package:ewc/screens/metrics/route_data.dart';
import 'package:ewc/service_locator.dart';
import 'package:ewc/services/auth_service/auth_service.dart';

/// This file manages the metrics service and provides functionality to fetch
///
/// Functions:
/// - `fetchAllRoutes()`: Fetches all the routes from the backend.

class MetricsService {
  // fetch all fo the route env table
  Future<List<JourneyRoute>> fetchAllRoutes() async {
    final response =
        await getIt<AuthService>().makeAuthenticatedRequest('route-env-data/');
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
  // fetch the last 30 days from the route env table
  Future<List<JourneyRoute>> fetchLast30Days() async {
    final response = await getIt<AuthService>().makeAuthenticatedRequest('route-env-data-30-days/');
    print(response.statusCode);
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
