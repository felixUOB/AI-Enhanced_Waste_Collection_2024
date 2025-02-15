import 'package:latlong2/latlong.dart';

class Stop {
  final int id;
  final String name;
  final LatLng location;
  bool visited;

  Stop({
    required this.id,
    required this.name,
    required this.location,
    this.visited = false // Initially set visited to false for each stop
  });
}
