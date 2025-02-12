import 'package:latlong2/latlong.dart';

class Stop {
  final String name;
  final LatLng location;
  bool visited;

  Stop({
    required this.name,
    required this.location,
    this.visited = false // Initially set visited to false for each stop
  });
}
