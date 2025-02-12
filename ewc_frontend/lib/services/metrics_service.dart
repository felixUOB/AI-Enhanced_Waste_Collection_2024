import 'dart:convert';
import 'package:ewc/screens/metrics/route_data.dart';
import 'package:ewc/services/auth_service.dart';

class MetricsService {
  final AuthService authService = AuthService();


  Future<List<JourneyRoute>> fetchAllRoutes() async {
    final response = await authService.makeAuthenticatedRequest('route_env_data/');
    // if the request is successful
    if (response.statusCode == 200){
      final data = jsonDecode(response.body) as List;
      List<JourneyRoute> routeList = [];
      for (var route in data){
        routeList.add(JourneyRoute(distance: route['distance'], mpg: route['mpg'], date: route['date']));
      }
      return routeList;
      // distance, mpg, date
    } else{
      throw Exception('Failed to load statistics data.');
    }
  }


}