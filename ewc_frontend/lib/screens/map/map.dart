import 'dart:async';
import 'package:ewc/service_locator.dart';
import 'package:ewc/notifiers/stops_notifier.dart';
import 'package:ewc/services/location_service.dart';
import 'package:ewc/services/route_service.dart';
import 'package:ewc/widgets/location_marker.dart';
import 'package:ewc/widgets/log_stop_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:ewc/widgets/route_polyline_layer.dart';
import 'package:ewc/widgets/marker_widget.dart';
import 'package:ewc/services/stops_service.dart';
import 'package:ewc/models/stop_model.dart';
import 'package:ewc/widgets/recentre_button.dart';
import 'package:ewc/widgets/start_journey_dialog.dart';
import 'package:ewc/widgets/end_journey_dialog.dart';

import 'package:provider/provider.dart';
import 'package:ewc/notifiers/location_notifier.dart';
import 'package:ewc/widgets/navigation_banner.dart';

// MapPage is a stateful widget displaying a map and plotting a route
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  // Creates and returns the private _MapPage state instance to manage the widget's state
  @override
  State<MapPage> createState() => _MapPage();
}

// Private State class for MapPage, manages state and map interactions
class _MapPage extends State<MapPage> with TickerProviderStateMixin {
  // Route variables
  final List<LatLng> _routePoints = [];
  final Map<List<double>, String> _routeInstructions = {};
  final List<Marker> _marker = [];
  late RouteService _routeService;
  final StopsService _stopsService = getIt<StopsService>();

  // Location variables
  late AnimatedMapController _animatedMapController;
  late StreamSubscription<ServiceStatus> _locationStatusStream;
  bool? _locationStatus;

  // Journey state management (tracks whether a journey is currently active)
  bool _journeyActive =
      false; // false means the journey hasn't started yet, true means it has.

  // User inputs (mileage / MPG)
  double _startMileage = 0;
  double _startMpg = 0;
  double _endMpg = 0;

  // State initialisation
  @override
  void initState() {
    super.initState();
    _animatedMapController = AnimatedMapController(
        vsync: this, duration: Duration(milliseconds: 1500));
    Provider.of<LocationProvider>(context, listen: false).initialiseLocationServices();
    _initialiseLocationStatusStream();
    _initializeEnvAndService();
  }

  void _initialiseLocationStatusStream() async {
    _locationStatus = await getIt<GeolocatorPlatform>().isLocationServiceEnabled();
    _locationStatusStream =
        getIt<GeolocatorPlatform>().getServiceStatusStream().listen((ServiceStatus status) {
      setState(() {
        _locationStatus = status == ServiceStatus.enabled;
      });
    });
  }

  // This function loads .env and initializes RouteService asynchronously
  Future<void> _initializeEnvAndService() async {
    try {
      await Provider.of<StopsProvider>(context, listen: false).initialiseStops();

      _routeService = getIt<RouteService>();

      await _drawStopsMarker(Colors.blue);

      await _fetchOptimizedRoute();
      //Depot location marker
      _marker.add(
          MarkerWidget.createMarker(LatLng(51.4533, -2.6257), Colors.black));
    } catch (e) {
      // Log the error and provide feedback
      _showErrorDialog(
          "Failed to initialize map service. Please check API key and network connection.");
    }
  }

  // Function to draw a complete route between all stops
  // ignore: unused_element
  Future<void> _drawCompleteRoute() async {
    // Alternatively store stops list as class attribute
    List<LatLng> route = [];
    List<Stop> stops = Provider.of<StopsProvider>(context, listen: false).stops;
    for (int i = 0; i < stops.length - 1; i++) {
      final start = stops[i];
      final end = stops[i + 1];
      final routePart = await _routeService.getRoute(
          start.location.latitude,
          start.location.longitude,
          end.location.latitude,
          end.location.longitude);
      route.addAll(routePart);
    }
    setState(() {
      _routePoints.clear();
      _routePoints.addAll(route);
    });
  }

  Future<void> _drawStopsMarker(Color color) async {
    List<Stop> stops = Provider.of<StopsProvider>(context, listen: false).stops;
    for (int i = 0; i < stops.length; i++) {
      _marker.add(MarkerWidget.createMarker(stops[i].location, color));
    }
  }

  // Fetches route data from the ORS API between the two given stops, entered by their ID.
  // ignore: unused_element
  Future<void> _fetchRoute(int firstStopID, int secondStopID) async {
    LatLng startPoint = await _stopsService.fetchStop(firstStopID);
    LatLng collectionPoint = await _stopsService.fetchStop(secondStopID);

    final startLat = startPoint.latitude, startLng = startPoint.longitude;
    final endLat = collectionPoint.latitude, endLng = collectionPoint.longitude;

    // Get route points from the API and update _routePoints with the data
    final List<LatLng> route =
        await _routeService.getRoute(startLat, startLng, endLat, endLng);

    setState(() {
      // Remove any existing points
      _routePoints.clear();
      // Add new route points
      _routePoints.addAll(route);
    });
  }

  // Optimized route planning
  Future<void> _fetchOptimizedRoute() async {
    try {
      List<Stop> stops = Provider.of<StopsProvider>(context, listen: false).stops;
      // List<LatLng> optimizedRoute = await _routeService.routePlanning(stops);
      RouteResult result = await _routeService.routePlanning(stops);
      List<LatLng> optimizedRoute = result.routeCoordinates;
      // ignore: unused_local_variable
      Map<List<double>, String> instructionsMap = result.instructionsMap;
      setState(() {
        _routePoints.clear();
        _routeInstructions.clear();
        _routePoints.addAll(optimizedRoute);
        _routeInstructions.addAll(instructionsMap);
      });
    } catch (e) {
      _showErrorDialog("Failed to fetch optimized route: $e");
    }
  }


  // Displays an error dialog with the provided message
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  IconData getInstructionIcon(String instruction) {
    instruction = instruction.toLowerCase();
    if (instruction.contains("left")) {
      return Icons.turn_left;
    } else if (instruction.contains("right")) {
      return Icons.turn_right;
    } else if (instruction.contains("straight")) {
      return Icons.straight;
    } else {
      return Icons.navigation;
    }
  }
  // To be used later with the useres location - for modification
  List<double>? getInstructionRangeKey(int userIndex) {
    // Find the first instruction range that the user's index falls within the defined range.
    List<double>? activeRange;
    _routeInstructions.forEach((range, instruction) {
      final start = range[0].toInt();
      final end = range[1].toInt();
      if (userIndex >= start && userIndex <= end) {
        activeRange = range;
      }
  });

  // Return the range (key) if found
  return activeRange;
}

  // Builds the main UI for the map screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
      children: [
        Positioned.fill(child: content()),
        // Overlay the NavigationBanner at the top of the map
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: NavigationBanner(
            visible: _journeyActive,
            instruction: _routeInstructions.values.elementAt(1),
            icon: getInstructionIcon(_routeInstructions.values.elementAt(1)),
          ),
        ),
        Positioned(
          left: 12.0,
          right: 12.0,
          bottom: 8.0,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _journeyActive ? Colors.red : Colors.green,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12.0),
            ),
            child: Text(
              _journeyActive ? 'End Journey' : 'Start Journey',
              style: const TextStyle(color: Colors.white,         
              fontWeight: FontWeight.bold,
              fontSize: 18,),
            ),
            onPressed: () {
              if (_journeyActive) {
                _showEndJourneyDialog();
              } else {
                _showStartJourneyDialog();
              }
            },
          ),
        ),
      ],
    ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 56.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            (_journeyActive) ?
            // Log visit button
            FloatingActionButton(
              heroTag: "log visit",
              child: const Icon(Icons.where_to_vote),
              onPressed: () {
                LogStopDialog.show(context,
                  (int stopID, int wasteCollected) {
                    _stopsService.postStopCollection(stopID, wasteCollected);
                    Provider.of<StopsProvider>(context, listen: false).setVisited(stopID);
                  }
                );
              },
            ) : const SizedBox(),
            (_journeyActive) ?
            const SizedBox(height: 10) : const SizedBox(),

            // ZOOM IN
            FloatingActionButton(
              heroTag: "zoom in",
              child: const Icon(Icons.add),
              onPressed: () {
                _animatedMapController.animatedZoomIn(duration: Duration(milliseconds: 500));

              },
            ),
            const SizedBox(height: 10), // Space between buttons

            // ZOOM OUT
            FloatingActionButton(
              heroTag: "zoom out",
              child: const Icon(Icons.remove),
              onPressed: () {
                _animatedMapController.animatedZoomOut(duration: Duration(milliseconds: 500));
              },
            ),
            const SizedBox(height: 10),
            
            RecentreButton(onPressed: () async {
              // If recentre button pressed recentre map over user location
              // Check if location permissions have been granted.
              if (await getLocationPermissions()) {
                if (context.mounted) {
                  Provider.of<LocationProvider>(context, listen: false).initialisePositionStream();
                  LatLng? location = Provider.of<LocationProvider>(context, listen: false).latestLocation;
                  if (location != null) {
                    _animatedMapController.animateTo(
                        dest: LatLng(
                            location.latitude, location.longitude),
                        zoom: 14);
                  }
                }
              } else {
                // Request permission if not already granted.
                if (await requestLocationPermissions()) {
                  if (context.mounted) {
    
                    Provider.of<LocationProvider>(context, listen: false).initialisePositionStream();
                    LatLng? location = Provider.of<LocationProvider>(context, listen: false).latestLocation;
                    if (location != null) {
                      _animatedMapController.animateTo(
                          dest: LatLng(
                              location.latitude, location.longitude),
                          zoom: 14);
                    }
                  }
                } else {
                  //User denied location permissions, show an alert
                  if (context.mounted) {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title : Text("Location Permission Required"),
                          content : Text("This app requires location to function properly. Please consider turning location permission on."),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context), //Dismiss dialog
                                child: Text("OK"))
                          ],
                        ),
                    );
                  }
                }
              }
            }
          )]
        )
      ),
    );
  }

  // Widget that creates and displays map with initial configurations, route and markers
  Widget content() {
    return Consumer<LocationProvider>(
      builder: (context, locationProvider, child) {
        return FlutterMap(
      mapController: _animatedMapController.mapController,
      options: const MapOptions(
        initialCenter: LatLng(51.4492, -2.5879),
        minZoom: 2.5,
        maxZoom: 19,
        initialZoom: 14,
        interactionOptions: InteractionOptions(
            flags:
                ~InteractiveFlag.doubleTapZoom & // Disable double tap to zoom
                    ~InteractiveFlag.rotate // Disable map rotation
            ),
      ),
      children: [
        // openStreetMapTileLayer, // Adds the OpenStreetMap tile layer to the map
        if (!getIt<Config>().inTestMode) openStreetMapTileLayer,
        
        RoutePolylineLayer(routePoints: _routePoints),
        MarkerLayer(markers: _marker),
        // Only display location marker if app can access location
        if (_locationStatus != null && locationProvider.latestLocation != null)
          if (_locationStatus!) LocationMarker(location: locationProvider.latestLocation!),
      ],
    );
      },
    );
  
  }

  // Tile layer for OpenStreetMap tiles
  TileLayer get openStreetMapTileLayer => TileLayer(
        urlTemplate:
            'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
        subdomains: ['a', 'b', 'c'],
        retinaMode: RetinaMode.isHighDensity(context),
        userAgentPackageName: 'dev.fleaflet.flutter_map.example',
      );

  // Delete old code implementation

  void _showStartJourneyDialog() {
    StartJourneyDialog.show(context, (double mileage, double mpg) {
      setState(() {
        _startMileage = mileage;
        _startMpg = mpg;
        _journeyActive = true;
      });
      debugPrint('Start Mileage: $_startMileage, Start MPG: $_startMpg');
    });
  }

  void _showEndJourneyDialog() {
    EndJourneyDialog.show(context, (double mpg) {
      setState(() {
        _endMpg = mpg;
        _journeyActive = false;
      });

      debugPrint('End MPG: $_endMpg');
    });
  }

  @override
  void dispose() {
    _locationStatusStream.cancel();
    super.dispose();
  }
}


class Config {
  bool inTestMode;
  Config({this.inTestMode = false});
}

