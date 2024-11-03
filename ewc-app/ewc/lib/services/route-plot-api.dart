// Import necessary packages for route service and geolocation handling
import 'package:open_route_service/open_route_service.dart';
import 'package:latlong2/latlong.dart';

// A service class to manage route fetching from OpenRouteService API
class RouteService {
  final OpenRouteService client;

  //Constructor for initialization of the OpenRouteService client with an API key 
  RouteService(String apiKey) : client = OpenRouteService(apiKey: apiKey);

  // Form Route between coordinates returning a list of LatLng objects representing the route
  Future<List<LatLng>> getRoute(double startLat, double startLng, double endLat, double endLng) async {

    // Fetch the route coordinates from OpenRouteService API using start and end coordinates
    final List<ORSCoordinate> routeCoordinates = await client.directionsRouteCoordsGet(
      startCoordinate: ORSCoordinate(latitude: startLat, longitude: startLng), 
      endCoordinate: ORSCoordinate(latitude: endLat, longitude: endLng),
      // Setting profile for heavy goods vehicles (HGV), suitable for routing large trucks,
      profileOverride: ORSProfile.drivingHgv,
    );

    // Convert the list of ORSCoordinate objects into LatLng objects representing the route to be display on a map
    return routeCoordinates.map((coordinate) => LatLng(coordinate.latitude, coordinate.longitude)).toList();
  }

}