import 'package:open_route_service/open_route_service.dart';
import 'package:latlong2/latlong.dart';

// A service class to manage route fetching from OpenRouteService API
class RouteService {
  final OpenRouteService client;

  //Constructor for initialization of the OpenRouteService client with an API key 
  RouteService(String apiKey) : client = OpenRouteService(apiKey: apiKey);

  // Helper method to validate latitude values
  bool _isValidLatitude(double latitude) {
    return latitude >= -90.0 && latitude <= 90.0;
  }

  // Helper method to validate longitude values
  bool _isValidLongitude(double longitude) {
    return longitude >= -180.0 && longitude <= 180.0;
  }




  // Form Route between coordinates returning a list of LatLng objects representing the route
  Future<List<LatLng>> getRoute(double startLat, double startLng, double endLat, double endLng) async {
    // Input Validation
    if (!_isValidLatitude(startLat) || !_isValidLatitude(endLat)) {
      throw ArgumentError('Latitude must be between -90 and 90 degrees.');
    }
    if (!_isValidLongitude(startLng) || !_isValidLongitude(endLng)) {
      throw ArgumentError('Longitude must be between -180 and 180 degrees.');
    }

    try {
      // Fetch the route coordinates from OpenRouteService API using start and end coordinates
      final List<ORSCoordinate> routeCoordinates = await client.directionsRouteCoordsGet(
        startCoordinate: ORSCoordinate(latitude: startLat, longitude: startLng), 
        endCoordinate: ORSCoordinate(latitude: endLat, longitude: endLng),
        // Setting profile for heavy goods vehicles (HGV), suitable for routing large trucks,
        profileOverride: ORSProfile.drivingHgv,
      );

      if (routeCoordinates.isEmpty) {
        throw Exception('No route could be found between the provided coordinates.');
      }
      // Convert the list of ORSCoordinate objects into LatLng objects representing the route to be display on a map
      return routeCoordinates.map((coordinate) => LatLng(coordinate.latitude, coordinate.longitude)).toList();
    } catch (e) {
      // Debugging error log
      print('Error fetching route: $e');
      // Rethrow the exception to allow higher-level handlers to manage it
      rethrow;
    }
  }


  Future<OptimizationData> routePlanning() async {
    final depot = LatLng(51.4682, -2.6103);
    final stops = [
      LatLng(51.4476, -2.5982),
      LatLng(51.4541, -2.6200),
      LatLng(51.4499, -2.5812),
    ];
    
    List<VroomJob> jobs = [];

    for (int idx = 0; idx < stops.length; idx++) {
      LatLng stop = stops[idx];
      jobs.add(VroomJob(
        id: idx + 1,
        location: ORSCoordinate(latitude: stop.latitude, longitude: stop.longitude),
      ));
    }


    List<VroomVehicle> vehicles = [];

    VroomVehicle vehicle = VroomVehicle(
      id: 1,
      start: ORSCoordinate(latitude: depot.latitude, longitude: depot.longitude),
      end: ORSCoordinate(latitude: depot.latitude, longitude: depot.longitude),
      profile: 'driving-hgv',
    );

    vehicles.add(vehicle);

    final response = await client.optimizationDataPost(jobs: jobs, vehicles: vehicles);
  
    if (response.routes.isEmpty) {
      throw Exception('No optimized route could be found.');
    }

    return response;

  }


}