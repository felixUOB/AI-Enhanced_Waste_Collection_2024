import 'dart:convert';
import 'package:ewc/screens/metrics/route_data.dart';
import 'package:ewc/service_locator.dart';
import 'package:ewc/services/auth_service/auth_service.dart';


class MetricsService {
  Future<List<JourneyRoute>> fetchAllRoutes() async {
        await getIt<AuthService>().makeAuthenticatedRequest('route_env_data/');
    // if the request is successful
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
}
