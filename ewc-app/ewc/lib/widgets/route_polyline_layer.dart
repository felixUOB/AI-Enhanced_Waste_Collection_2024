import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ewc/imports/imports.dart';
import 'package:latlong2/latlong.dart';

class RoutePolylineLayer extends StatelessWidget{
  final List<LatLng> routePoints;

  RoutePolylineLayer({
    super.key,
    required this.routePoints,
    });

  @override
  Widget build(BuildContext context) {
    return PolylineLayer(
      polylines: [
        Polyline(
          points: routePoints,
          strokeWidth: 4.0,
          color: Colors.blue,
        ),
      ],
    );
  }
}
