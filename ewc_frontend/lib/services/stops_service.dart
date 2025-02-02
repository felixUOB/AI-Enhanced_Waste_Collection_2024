import 'dart:convert';
import 'package:ewc/models/stop_model.dart';
import 'package:ewc/services/auth_service.dart';
import 'package:latlong2/latlong.dart';

class StopsService {
  final AuthService authService = AuthService();

  Future<LatLng> fetchStop(int stopID) async {
    final response = await authService.makeAuthenticatedRequest('stops/$stopID');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final lat = data['latitude'];
      final lng = data['longitude'];
      return LatLng(lat, lng);
    } else {
      throw Exception('Failed to load collection point.');
    }
  }

  Future<List<Stop>> fetchAllStops() async {
    final response = await authService.makeAuthenticatedRequest('stops');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      List<Stop> stopsList = [];
      for (var point in data) {
        stopsList.add(Stop(
            name: point['location_name'],
            location: LatLng(point['latitude'], point['longitude']))
        );
      }
      return stopsList;
    } else {
      throw Exception('Failed to load collection points');
    }
  }
}
