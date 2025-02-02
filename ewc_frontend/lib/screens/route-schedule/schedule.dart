import 'package:ewc/services/route_plot_service.dart';
import 'package:ewc/services/stops_service.dart';
import 'package:ewc/theme/theme_constants.dart';
import 'package:ewc/widgets/timeline_tile.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:ewc/models/stop_model.dart';
import 'package:latlong2/latlong.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _Schedule();
}

class _Schedule extends State<Schedule> {
  final List<Stop> _route = [
    Stop(name: 'southdown', location: LatLng(51.4963871, -2.6230827)),
    Stop(name: 'hill grove', location: LatLng(51.4898217, -2.6021408)),
    Stop(name: 'coombe dingle', location: LatLng(51.4980162, -2.6411713))
  ];
  List<double>? _stopTimes;
  final _stopsService = StopsService();

  @override
  void initState() {
    super.initState();
    initialiseStops();
  }

  Future<void> initialiseStops() async {
    try {
      // Attempt to load the .env file
      await dotenv.load(fileName: '.env');

      // Check if the API key exists in .env; show an error message if not
      final apiKey = dotenv.env['API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception("API key missing in .env file.");
      }
      // Initialize RouteService with the valid API key
      //_route = await _stopsService.fetchAllStops();
      RouteService routeService = RouteService(dotenv.env['API_KEY']!);
      _stopTimes = await routeService.getStopTimes(_route[0].location, _route.map((route) => route.location).toList());

  } catch (e) {
      // Log the error and provide feedback
      throw Exception("Failed to initialize map service. Please check API key and network connection.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

// ------------List of stops------------
      // makes a scrollable list
      body: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.0),
          child: ListView.builder(
            itemCount: _route.length,
            itemBuilder: (BuildContext context, int index) {
              return CustomTimelineTile(
                inPast: _route[index].visited, // checks if its in the past or in the future
                isFirst: index == 0, // if it is the first index set the property to true
                isLast: index == _route.length - 1, // checks if its the last in the list
                eventCard: Row(children: [
// ------------Stop name text------------
                  Expanded(
                    child: Text(_route[index].name,
                      textAlign:
                        TextAlign.left, // display the stop name
                      style: AppTheme().constWhiteTextLarge)
                  ),
// ------------Minutes text------------
                  Expanded(
                    child: (_stopTimes != null) ?
                    Text(
                      _stopTimes![index].toString(), // display the stop time
                      textAlign: TextAlign.right,
                      style: AppTheme().constWhiteTextLarge,
                    ): Text(
                      "Getting Data",
                      textAlign: TextAlign.right,
                      style: AppTheme().constWhiteTextLarge,
                    )
                  )
                ]),
              );
            }
          )
        )
      )
    );
  }
}

// // checkTimeLabel returns true if the time given to it is before the current time
// bool checkTimeLabel(RouteStop timeLable) {
//   DateTime now = DateTime.now();
//   if (timeLable.time.isBefore(now)) {
//     return true;
//   } else {
//     return false;
//   }
// }
