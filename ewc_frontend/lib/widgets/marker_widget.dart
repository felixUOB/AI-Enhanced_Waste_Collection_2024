import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// class MarkerWidget {
//   static Marker createMarker(LatLng location, Color color) {
//     return Marker(
//       width: 60.0,
//       height: 60.0,
//       point: location,
//       child: GestureDetector(
//         onTap: () {
//           print('Widget taped');
//         },
//         child: Align(alignment: Alignment.topCenter,
//           child: Icon(
//             Icons.location_on,
//             color: color,
//             size: 30,
//           )
//         ),
//       ),
//     );
//   }
// }

class MarkerWidget {
  static Marker createMarker(BuildContext context, LatLng location, Color color) {
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
                title: const Text('AlertDialog Title'),
                content: const Text('AlertDialogue description'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Cancel'),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'More Info'),
                    child: const Text('More Info'),
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