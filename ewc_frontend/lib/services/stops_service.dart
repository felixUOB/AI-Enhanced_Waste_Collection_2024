import 'dart:convert';
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

  Future<List<LatLng>> fetchAllStops() async {
    final response = await authService.makeAuthenticatedRequest('stops');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      List<LatLng> latLngStopsList = [];
      for (var point in data) {
        latLngStopsList.add(LatLng(point['latitude'], point['longitude']));
      }
      return latLngStopsList;
    } else {
      throw Exception('Failed to load collection points');
    }
  }
}
