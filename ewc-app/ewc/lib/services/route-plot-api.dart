import 'package:open_route_service/open_route_service.dart';
import 'package:latlong2/latlong.dart';

class RouteService {
  final OpenRouteService client;

  //Constructor for initialization of the OpenRouteService client with an API key 
  RouteService(String apiKey) : client = OpenRouteService(apiKey: apiKey);

  // Fetch the route between two coordinates
      // Form Route between coordinates
  Future<List<LatLng>> getRoute(double startLat, double startLng, double endLat, double endLng) async {
    final List<ORSCoordinate> routeCoordinates = await client.directionsRouteCoordsGet(
      startCoordinate: ORSCoordinate(latitude: startLat, longitude: startLng), 
      endCoordinate: ORSCoordinate(latitude: endLat, longitude: endLng),
    );

  // Map route coordinates to a list of LatLng
    return routeCoordinates.map((coordinate) => LatLng(coordinate.latitude, coordinate.longitude)).toList();
  }

}