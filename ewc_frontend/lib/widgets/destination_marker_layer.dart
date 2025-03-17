import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// This file manages the destination marker layer.
///
/// Functions:
/// - `build()`: Builds the destination marker layer.

class DestinationMarker extends StatelessWidget{
  final LatLng location;

  // ignore: prefer_const_constructors_in_immutables
  DestinationMarker({
    super.key,
    required this.location,
    });

  @override
  Widget build(BuildContext context) {
    return MarkerLayer(
      markers: [
        Marker(
          point: location,
          width: 60,
          height: 60,
          alignment: Alignment.bottomCenter,
          child: Icon(
            Icons.location_pin,
            size: 60,
            color: Colors.red,
          ),
        ),
      ],

    );
  }
}
