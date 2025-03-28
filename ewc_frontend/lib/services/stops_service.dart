import 'dart:convert';
import 'package:ewc/models/stop_model.dart';
import 'package:ewc/service_locator.dart';
import 'package:ewc/services/auth_service/auth_service.dart';
import 'package:latlong2/latlong.dart';

/// This file manages the stops service and provides functionality to interact with the list of stops.
///
/// Functions:
/// - `postStopCollection(int stopID, int weightCollected)`: Posts the stop collection to the backend.
/// - `fetchStop(int stopID)`: Fetches a stop from the backend.
/// - `fetchAllStops()`: Fetches all the stops from the backend.

class StopsService {
  
  Future<void> postStopCollection(int stopID, int weightCollected) async {
    final body = {'stop': stopID, 'weight_collected': weightCollected};
    final response = await getIt<AuthService>().makeAuthenticatedPostRequest('stop_collection/', body);
    if (response.statusCode != 201) {
      throw Exception('Failed to register stop collection.');
    }
  }

  Future<LatLng> fetchStop(int stopID) async {
    final response = await getIt<AuthService>().makeAuthenticatedRequest('stops/$stopID');

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
    final response = await getIt<AuthService>().makeAuthenticatedRequest('stops/');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      List<Stop> stopsList = [];
      for (var point in data) {
        stopsList.add(Stop(
          id: point['stop_id'],
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
