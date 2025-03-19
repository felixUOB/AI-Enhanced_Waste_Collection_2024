import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';

/// This file manages the route polyline layer widget.
///
/// Functions:
/// - `build()`: Builds the route polyline layer.

class RoutePolylineLayer extends StatelessWidget{
  final List<LatLng> routePoints;
  final int closestIndex;

  // ignore: prefer_const_constructors_in_immutables
  RoutePolylineLayer({
    super.key,
    required this.routePoints,
    required this.closestIndex,
    });

  @override
  Widget build(BuildContext context) {
    // Divide the route points into 2 segments traveled and remaining 
    final List<LatLng> traveledPoints = routePoints.isNotEmpty ? routePoints.sublist(0, min(closestIndex + 1, routePoints.length)) : [];
    final List<LatLng> remainingPoints = routePoints.isNotEmpty ? routePoints.sublist(min(closestIndex, routePoints.length)) : [];
    return PolylineLayer(
      polylines: [
        Polyline(
          points: traveledPoints, // Route that has been already traveled
          strokeWidth: 5.0,
          color: const Color.fromARGB(255, 140, 203, 255),
        ),
        Polyline(
          points: remainingPoints, // Route that is yet to be traveled
          strokeWidth: 5.0,
          color: Colors.blue,
        ),
      ],
    );
  }
}
