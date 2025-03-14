import 'package:ewc/screens/route-schedule/schedule_tile.dart';
import 'package:ewc/screens/route-schedule/stop_view.dart';
import 'package:ewc/service_locator.dart';
import 'package:ewc/notifiers/stops_notifier.dart';
import 'package:ewc/services/route_service.dart';
import 'package:ewc/widgets/timeline_tile.dart';
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
  List<int>? _stopTimes;
  final _routeService = getIt<RouteService>();

  @override
  void initState() {
    super.initState();
    initialiseStops();
  }

  Future<void> initialiseStops() async {
    try {
      // The next block of code creates a list _stopTimes where each element
      // is the amount of time in minutes from the user's location to that stop
      // while following the route
      if (mounted) {
        List<Stop> route = Provider.of<StopsProvider>(context, listen: false).stops;
        LatLng? location = Provider.of<LocationProvider>(context, listen: false).latestLocation;
        if (location != null) {
          // SelectedStops filters out already visited stops from the route calculation
          
          var selectedStops = route.where((route) => !route.visited).map(
            (route) => route.location).toList();
          _stopTimes = [];
          for (var _ in route.where((route) => route.visited)) {
            // Pad out the stop times with 0s when some stops have been visited
            _stopTimes?.add(0);
          }
          _stopTimes?.addAll(
              await _routeService.getStopTimes(location, selectedStops));
        }
      }
    } catch (e) {
      // Log the error and provide feedback
      throw Exception(
          "Failed to initialize stop service.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // Add refresh indicator to allow drag down refresh
      body: RefreshIndicator(

        onRefresh: () async {
          // When user refreshes, recalculate stop times based off of location and set new state
          List<Stop> route = Provider.of<StopsProvider>(context, listen: false).stops;
          LatLng? location = Provider.of<LocationProvider>(context, listen: false).latestLocation;
          if (location != null) {
            // SelectedStops filters out already visited stops from the route calculation
            var selectedStops = route.where((route) => !route.visited).map((route) => route.location).toList();
            List<int> newStops = [];
            for (var _ in route.where((route) => route.visited)) {
              newStops.add(0); // Pad out the stop times with 0s when some stops have been visited
            }
            newStops.addAll(await _routeService.getStopTimes(location, selectedStops));
            setState(() {
              _stopTimes = newStops; // Force reload of widget with new stop times
            });
          }
        },

        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          // makes a scrollable list
          child: Consumer<StopsProvider>(
            builder: (context, stopsProvider, child) {
              final route = stopsProvider.stops;
              return ListView.builder(
                itemCount: route.length,
                itemBuilder: (BuildContext context, int index) {
                  return CustomTimelineTile(
                    inPast: route[index].visited,
                    // checks if its in the past or in the future
                    isFirst: index == 0,
                    // if it is the first index set the property to true
                    isLast: index == route.length - 1,
                    // checks if its the last in the list
                    eventCard: ScheduleTile(
                      name: route[index].name,
                      visited: route[index].visited,
                      minutes: (!route[index].visited && _stopTimes != null) ? _stopTimes![index] : 0,
                      onPressed: () {
                        Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => StopView(
                              id: route[index].id,
                              name: route[index].name,
                              visited: route[index].visited,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              );
            }
          )
        )
      )
    );
  }
}
