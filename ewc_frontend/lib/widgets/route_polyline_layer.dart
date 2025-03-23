import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';
import 'package:geolocator/geolocator.dart';

/// This file manages the route polyline layer widget.
///
/// Functions:
/// - `build()`: Builds the route polyline layer.
/// - `projectPoint()`: Computes the projection of current point onto the segment defined by p1 and p2.
/// 
/// Logic of splitting the route polyline layer into 2 segments travelled and remaining:
///   1. isClosestIndexBeforeUserLocation is true if the closest index is ahead of the user's current location i.e. the user has not reached the closest index yet.
///      isClosestIndexBeforeUserLocation is false if the closest index is behind the user's current location i.e. the user has already passed the closest index.
///   2 if isClosestIndexBeforeUserLocation is true then project the users current location onto the line defined betwen closest index -1 and closest index
///   3 otherwise if false then project the users current location onto the line defined betwen closest index and closest index + 1
///   4. return the polyline layer with the travelled and remaining points
///   5. if current location is null return the whole route as one polyline

// Computes the projection of current onto the segment defined by p1 and p2.
LatLng projectPoint(LatLng p1, LatLng p2, LatLng current) {
  double dx = p2.latitude - p1.latitude;
  double dy = p2.longitude - p1.longitude;
  double dotProduct = (current.latitude - p1.latitude) * dx + (current.longitude - p1.longitude) * dy;
  // Compute the squared length of the segment
  double segmentLengthSq = dx * dx + dy * dy;
  // Find the projection factor (t)
  double t = segmentLengthSq > 0 ? dotProduct / segmentLengthSq : 0;
  t = t.clamp(0.0, 1.0);
  return LatLng(p1.latitude + t * dx, p1.longitude + t * dy);
}

class RoutePolylineLayer extends StatelessWidget{
  final List<LatLng> routePoints;
  final int closestIndex;
  final LatLng? currentLocation;
  final bool isClosestIndexBeforeUserLocation;

  // ignore: prefer_const_constructors_in_immutables
  RoutePolylineLayer({
    super.key,
    required this.routePoints,
    required this.closestIndex,
    required this.currentLocation,
    required this.isClosestIndexBeforeUserLocation,
    });

  @override
  Widget build(BuildContext context) {
    // If currentLocation is null: return the whole route as one polyline.
    if (currentLocation == null) {
      return PolylineLayer(
        polylines: [
          Polyline(
            points: routePoints,
            strokeWidth: 5.0,
            color: Colors.blue,
          ),
        ],
      );
    }

    List<LatLng> travelledPoints = [];
    List<LatLng> remainingPoints = [];
    LatLng projectedPoint;

    if (routePoints.length >= 2) {
      // Case when isClosestIndexBeforeUserLocation is true: the closest index is ahead of the user's current location i.e. the user has not reached the closest index yet.
      if (isClosestIndexBeforeUserLocation && closestIndex > 0) {
        // Project the current location onto the segment defined by the closestIndex - 1(Start of that segment/line)  and closestIndex (End of that segment/line).
        final segmentStart = routePoints[closestIndex - 1];
        final segmentEnd = routePoints[closestIndex];
        projectedPoint = projectPoint(segmentStart, segmentEnd, currentLocation!);
        // Divide the route points into 2 segments travelled and remaining based on the projected point calculated.
        travelledPoints = [
          ...routePoints.sublist(0, closestIndex - 1),
          projectedPoint,
        ];

        remainingPoints = [
          projectedPoint,
          ...routePoints.sublist(closestIndex),
        ];

      // Case when isClosestIndexBeforeUserLocation is false: the closest index is behind the user's current location i.e. the user has already passed the closest index.
      } else if (!isClosestIndexBeforeUserLocation && closestIndex < routePoints.length - 1) {
        // Project the current location onto the segment defined by the closestIndex (Start of that segment/line) and closestIndex + 1 (End of that segment/line).
        final segmentStart = routePoints[closestIndex];
        final segmentEnd = routePoints[closestIndex + 1];
        projectedPoint = projectPoint(segmentStart, segmentEnd, currentLocation!);
        // Divide the route points into 2 segments travelled and remaining based on the projected point calculated.
        travelledPoints = [
          ...routePoints.sublist(0, closestIndex),
          projectedPoint,
        ];

        remainingPoints = [
          projectedPoint,
          ...routePoints.sublist(closestIndex + 1),
        ];

      } else {
        travelledPoints = routePoints;
        remainingPoints = [];
      }
    } else {
      travelledPoints = routePoints;
      remainingPoints = [];
    }

    return PolylineLayer(
      polylines: [
        Polyline(
          points: travelledPoints, // Route that has been already travelled
          strokeWidth: 5.0,
          color: const Color.fromARGB(255, 140, 203, 255),
        ),
        Polyline(
          points: remainingPoints, // Route that is yet to be travelled
          strokeWidth: 5.0,
          color: Colors.blue,
        ),
      ],
    );
  }
}
