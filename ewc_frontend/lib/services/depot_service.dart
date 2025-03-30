import 'dart:convert';
import 'package:ewc/models/depot_model.dart';
import 'package:ewc/service_locator.dart';
import 'package:ewc/services/auth_service/auth_service.dart';
import 'package:latlong2/latlong.dart';


/// This file manages the route service and provides functionality to fetch
///
/// Functions:
/// - `fetchDepoLocation()`: Creates a new RouteService instance.

class DepotService {

  Future<Depot> fetchDepoLocation() async {
    final response = await getIt<AuthService>().makeAuthenticatedRequest('get-depo/');
    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');
    if (response.statusCode == 200){
      final data = jsonDecode((response.body)) as List;
      return Depot(location: LatLng(data[0]['latitude'], data[0]['longitude']));
    } else{
      print(response.statusCode);
    }
    return Depot(location: LatLng(0,0));
  }
}