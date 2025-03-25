import 'package:latlong2/latlong.dart';

class Stop {
  final int id;
  final String name;
  final LatLng location;
  final String? description;
  bool visited;

  Stop({
    required this.id,
    required this.name,
    required this.location,
    this.description,
    this.visited = false // Initially set visited to false for each stop
  });
}
