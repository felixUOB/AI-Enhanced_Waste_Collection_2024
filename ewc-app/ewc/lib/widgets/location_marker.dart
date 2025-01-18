import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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
          child: Icon(Icons.my_location)
        )
      ]
    );
  }
}