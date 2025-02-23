import 'dart:async';
import 'package:ewc/service_locator.dart';
import 'package:ewc/services/location_service.dart';
import 'package:ewc/widgets/location_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:ewc/services/route_service.dart';
import 'package:ewc/widgets/route_polyline_layer.dart';
import 'package:ewc/widgets/marker_widget.dart';
import 'package:ewc/services/stops_service.dart';
import 'package:ewc/models/stop_model.dart';
import 'package:ewc/widgets/recentre_button.dart';
import 'package:ewc/widgets/start_journey_dialog.dart';
import 'package:ewc/widgets/end_journey_dialog.dart';

import 'package:provider/provider.dart';
import 'package:ewc/notifiers/location_notifier.dart';

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
  final List<Marker> _marker = [];
  late RouteService _routeService;
  final StopsService _stopsService = StopsService();
  late List<Stop> _stops = [];

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
    Provider.of<LocationProvider>(context, listen: false)
        .initialiseLocationServices();
    _initialiseLocationStatusStream();
    _initializeEnvAndService();
  }

  void _initialiseLocationStatusStream() async {
    _locationStatus = await Geolocator.isLocationServiceEnabled();
    _locationStatusStream =
        Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
      setState(() {
        _locationStatus = status == ServiceStatus.enabled;
      });
    });
  }

  // This function loads .env and initializes RouteService asynchronously
  Future<void> _initializeEnvAndService() async {
    try {
      _stops = await _stopsService.fetchAllStops();

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
    for (int i = 0; i < _stops.length - 1; i++) {
      final start = _stops[i];
      final end = _stops[i + 1];
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
    for (int i = 0; i < _stops.length; i++) {
      _marker.add(MarkerWidget.createMarker(_stops[i].location, color));
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
      List<LatLng> optimizedRoute = await _routeService.routePlanning(_stops);
      setState(() {
        _routePoints.clear();
        _routePoints.addAll(optimizedRoute);
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

  // Builds the main UI for the map screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: content(),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              // Single button toggling journey start/end
              Expanded(
                child: ElevatedButton(
                  child: Text(_journeyActive ? 'End Journey' : 'Start Journey'),
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
        ),
        floatingActionButton:
            Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          //ZOOM IN
          FloatingActionButton(
            heroTag: "zoom in",
            child: const Icon(Icons.add),
            onPressed: () {
              _animatedMapController.animatedZoomIn(
                  duration: Duration(milliseconds: 500));
            },
          ),
          const SizedBox(height: 10), // Space between buttons
          FloatingActionButton(
            heroTag: "zoom out",
            child: const Icon(Icons.remove),
            onPressed: () {
              _animatedMapController.animatedZoomOut(
                  duration: Duration(milliseconds: 500));
            },
          ),
          const SizedBox(height: 10),
          RecentreButton(onPressed: () async {
            // If recentre button pressed recentre map over user location
            // Check if location permissions have been granted.
            if (await getLocationPermissions()) {
              if (context.mounted) {
                Provider.of<LocationProvider>(context, listen: false)
                    .initialisePositionStream();
                LatLng? location =
                    Provider.of<LocationProvider>(context, listen: false)
                        .latestLocation;
                if (location != null) {
                  _animatedMapController.animateTo(
                      dest: LatLng(location.latitude, location.longitude),
                      zoom: 14);
                }
              }
            } else {
              // Request permission if not already granted.
              if (await requestLocationPermissions()) {
                if (context.mounted) {
                  Provider.of<LocationProvider>(context, listen: false)
                      .initialisePositionStream();
                  LatLng? location =
                      Provider.of<LocationProvider>(context, listen: false)
                          .latestLocation;
                  if (location != null) {
                    _animatedMapController.animateTo(
                        dest: LatLng(location.latitude, location.longitude),
                        zoom: 14);
                  }
                }
              } else {
                //User denied location permissions, show an alert
                if (context.mounted) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Location Permission Required"),
                      content: Text(
                          "This app requires location to function properly. Please consider turning location permission on."),
                      actions: [
                        TextButton(
                            onPressed: () =>
                                Navigator.pop(context), //Dismiss dialog
                            child: Text("OK"))
                      ],
                    ),
                  );
                }
              }
            }
          } // Space for recentre button
              )
        ]));
  }

  // Widget that creates and displays map with initial configurations, route and markers
  Widget content() {
    LatLng? location = Provider.of<LocationProvider>(context).latestLocation;
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
        openStreetMapTileLayer, // Adds the OpenStreetMap tile layer to the map
        RoutePolylineLayer(routePoints: _routePoints),
        MarkerLayer(markers: _marker),
        // Only display location marker if app can access location
        if (_locationStatus != null && location != null)
          if (_locationStatus!) LocationMarker(location: location),
      ],
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
