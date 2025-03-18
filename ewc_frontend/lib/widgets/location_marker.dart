import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// This file manages the location marker layer.
///
/// Functions:
/// - `build()`: Builds the location marker layer.

class LocationMarker extends StatelessWidget {
  final LatLng location;

  const LocationMarker ({
    super.key,
    required this.location
  });

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      markers: [
        Marker(
          point: location,
          width: 20,
          height: 20,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
              border: Border.all(
                color: Colors.white,
                width: 2.0,
              ),
            )
          )
        )
      ]
    );
  }
}