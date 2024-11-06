import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ewc/imports/imports.dart';
import 'package:latlong2/latlong.dart';

class DestinationMarker extends StatelessWidget{
  final LatLng location;

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
