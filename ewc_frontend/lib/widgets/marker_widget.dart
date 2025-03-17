import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// This file manages the marker widget.
///
/// Functions:
/// - `createMarker()`: Creates a marker at the specified location.

class MarkerWidget {
  static Marker createMarker(LatLng location, Color color) {
    return Marker(
      width: 60.0,
      height: 60.0,
      point: location,
      child: Align(alignment: Alignment.topCenter,
        child: Icon(
          Icons.location_on,
          color: color,
          size: 30,
        )
      ),
    );
  }
}

