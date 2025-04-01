import 'dart:convert';
import 'package:ewc/models/stop_model.dart';
import 'package:ewc/service_locator.dart';
import 'package:ewc/services/auth_service/auth_service.dart';
import 'package:latlong2/latlong.dart';


/// This file manages the route service and provides functionality to fetch
///
/// Functions:
/// - `fetchDepotLocation()`: Creates a new RouteService instance.

class DepotService {

  Future<Stop> fetchDepotLocation() async {
    final response = await getIt<AuthService>().makeAuthenticatedRequest('get-depot/');
    if (response.statusCode == 200){
      final data = jsonDecode((response.body)) as List;
      return Stop(id: -1, name: 'Depot', location: LatLng(data[0]['latitude'], data[0]['longitude']));
    } else{
      print(response.statusCode);
    }
    return Stop(id: -1, name: 'Depot', location: LatLng(0,0));
  }
}