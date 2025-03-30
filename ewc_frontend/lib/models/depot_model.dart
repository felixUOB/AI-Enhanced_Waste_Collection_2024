import 'package:latlong2/latlong.dart';

/// Represents the depot for the start of the journey.
/// the depot has 
/// The location is represented by a [LatLng] object from the `latlong2` package.

class Depot {
  final LatLng location;

  Depot({
    required this.location,
  });
}