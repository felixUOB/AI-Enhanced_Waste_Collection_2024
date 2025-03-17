import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

/// This file manages the marker widget.
///
/// Functions:
/// - `createMarker()`: Creates a marker at the specified location.

class MarkerWidget {
  static Marker createMarker(String name, BuildContext context, LatLng location, Color color, bool visited) {
    return Marker(
      width: 60.0,
      height: 60.0,
      point: location,
      child: GestureDetector(
        onTap: 
          () => showDialog<String>(
            context: context, 
            builder: 
              (BuildContext context) => AlertDialog(
                title: Text(name),
                content: Text("Latitude: ${location.latitude}\nLongitude: ${location.longitude}\nVisited: $visited"),
                actions: <Widget>[
                  TextButton(
                    // clear the notification
                    onPressed: () => Navigator.pop(context, 'More Info'),
                    child: const Text('More Info'),
                  ),
                  TextButton(
                    // link to the schedule page
                    onPressed: () => Navigator.pop(context, 'OK'),
                    child: const Text('OK'),
                  ), 
                ]
              ) 
            ),
        child: Align(alignment: Alignment.topCenter,
          child: Icon(
            Icons.location_on,
            color: color,
            size: 30,
          )
        ),
      ),
    );
  }
}