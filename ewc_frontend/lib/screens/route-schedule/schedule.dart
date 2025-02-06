import 'package:ewc/services/route_plot_service.dart';
import 'package:ewc/services/stops_service.dart';
import 'package:ewc/theme/theme_constants.dart';
import 'package:ewc/widgets/timeline_tile.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:ewc/models/stop_model.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:ewc/notifiers/location_notifier.dart';

class Schedule extends StatefulWidget {
  const Schedule({super.key});

  @override
  State<Schedule> createState() => _Schedule();
}

class _Schedule extends State<Schedule> {
  late List<Stop> _route = [];
  List<int>? _stopTimes;
  late RouteService _routeService;
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
      _route = await _stopsService.fetchAllStops();
      _routeService = RouteService(dotenv.env['API_KEY']!);
      if (mounted) {
        LatLng? location = Provider.of<LocationProvider>(context, listen: false).latestLocation;
        if (location != null) _stopTimes = await _routeService.getStopTimes(location, _route.map((route) => route.location).toList());
      }
  } catch (e) {
      // Log the error and provide feedback
      throw Exception("Failed to initialize map service. Please check API key and network connection.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Add refresh indicator to allow drag down refresh
      body: RefreshIndicator(
        onRefresh: () async {
          // When user refreshes, recalculate stop times based off of location and set new state
          LatLng? location = Provider.of<LocationProvider>(context, listen: false).latestLocation;
          if (location != null) {
            var newStops = await _routeService.getStopTimes(
                location, _route.map((route) => route.location).toList());
            setState(() {
              _stopTimes = newStops; // Force reload of widget with new stop times
            });
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          // makes a scrollable list
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
                    child: (_stopTimes != null && !_route[index].visited) ?
                    Text(
                      "${_stopTimes![index]} mins", // display the stop time
                      textAlign: TextAlign.right,
                      style: AppTheme().constWhiteTextLarge,
                    ): Text(
                      "",
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
