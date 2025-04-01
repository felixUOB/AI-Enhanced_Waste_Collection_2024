import 'package:ewc/screens/route-schedule/stop_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:ewc/models/stop_model.dart';

/// This file manages the marker widget.
///
/// Functions:
/// - `createMarker()`: Creates a marker at the specified location.

class MarkerWidget {
  static Marker createMarker(Stop stop, BuildContext context, Color color) {
    return Marker(
      width: 60.0,
      height: 60.0,
      point: stop.location,
      child: GestureDetector(
        onTap: 
          () => showDialog<String>(
            context: context, 
            builder: 
              (BuildContext context) => AlertDialog(
                title: Text(stop.name),
                content: Text("Latitude: ${stop.location.latitude}\nLongitude: ${stop.location.longitude}\nVisited: ${stop.visited}"),
                actions: <Widget>[
                  // Id of -1 reserved for depot, no more info when depot clicked
                  stop.id != -1 ?
                  TextButton(
                    // clear the notification
                    onPressed: () {
                      Navigator.push(context,
                        MaterialPageRoute(
                          builder: (context) => StopView(
                            id: stop.id,
                            name: stop.name,
                            visited: stop.visited,
                            description: stop.description,
                          ),
                        ),
                      );
                    },
                    child: const Text('More Info'),
                  ) : SizedBox.shrink(),
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