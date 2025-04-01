import 'package:latlong2/latlong.dart';

/// Represents a stop in the journey.
/// Each stop has an id, name, location, description, and a boolean value indicating if the stop has been visited.
/// The location is represented by a [LatLng] object from the `latlong2` package.

class Stop {
  final int id;
  final String name;
  final LatLng location;
  final String? description;
  bool visited;

  /// Creates a new stop with an [id], [name], [location], and [description].
  /// The [visited] flag defaults to `false`.
  Stop({
    required this.id,
    required this.name,
    required this.location,
    this.description,
    this.visited = false
  });
}