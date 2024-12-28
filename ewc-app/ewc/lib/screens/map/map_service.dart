import 'package:latlong2/latlong.dart';
import '../../services/route_plot_api.dart';

class RouteProvider {
  final RouteService routeService;
  final List<LatLng> _routePoints = [];
  String? errorMessage;

  RouteProvider({required this.routeService});

  List<LatLng> get routePoints => List.unmodifiable(_routePoints);

  Future<List<LatLng>> fetchRoute(
      {required double startLat,
      required double startLng,
      required double endLat,
      required double endLng}) async {
    try {
      errorMessage = null;
      final List<LatLng> route =
          await routeService.getRoute(startLat, startLng, endLat, endLng);
      _routePoints.clear();
      _routePoints.addAll(route);
    } catch (e) {
      errorMessage = "Failed to fetch route: $e";
    }
    return _routePoints;
  }
}
