import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MarkerWidget {
  static Marker createMarker(LatLng location, Color color) {
    return Marker(
      width: 80.0,
      height: 80.0,
      point: location,
      child: Icon(
        Icons.location_on,
        color: color,
        size: 40.0,
      ),
    );
  }
}

