// Import necessary packages for route service and geolocation handling
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
      throw e;
    }
  }




}