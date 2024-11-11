import 'package:flutter/material.dart';
import 'package:ewc/api/auth_service.dart';
import 'package:open_route_service/open_route_service.dart';
import 'package:latlong2/latlong.dart';
import '../../services/route-plot-api.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// class RouteSchedulePage extends StatefulWidget {
//   @override
//   _RouteSchedulePageState createState() => _RouteSchedulePageState();
// }
//
// class _RouteSchedulePageState extends State<RouteSchedulePage> {
//   // Instance of RouteService
//   RouteService routeService = RouteService(dotenv.env['API_KEY']!);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Route Schedule')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: () async {
//                 try {
//                   // Example of fetching route between two points
//                   List<LatLng> route = await routeService.getRoute(51.509865, -0.118092, 51.5074, -0.1278);
//                   print('Route Coordinates: $route');
//                 } catch (e) {
//                   print('Error fetching route: $e');
//                 }
//               },
//               child: Text('Fetch Route'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class Schedule extends StatelessWidget {
  // Hardcoded 'stop name' and 'minutes until stop reached' data
  // until map api is implemented
  final routes = const [
    ["stop 1",5],
    ["stop 2",8],
    ["stop 3",11],
    ["stop 4",15],
  ];

  const Schedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],

// ------------Top app bar------------

      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        centerTitle: true,
        toolbarHeight: 75,
        title: const Text('Schedule',
            style: TextStyle(fontFamily: 'Questrial', fontSize: 32))
      ),

// ------------List of stops------------
      body: SafeArea(
          child: ScheduleStopList(content: routes)),
    );
  }
}