import 'package:ewc/services/auth_service.dart';
import 'dart:async';
import 'package:ewc/services/location_service.dart';
import 'package:ewc/widgets/location_marker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ewc/services/route_plot_service.dart';
import 'package:ewc/widgets/route_polyline_layer.dart';
import 'package:ewc/widgets/marker_widget.dart';
import 'package:ewc/services/stops_service.dart';

import 'package:ewc/widgets/recentre_button.dart';

// MapPage is a stateful widget displaying a map and plotting a route
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  // Creates and returns the private _MapPage state instance to manage the widget's state
  @override
  State<MapPage> createState() => _MapPage();
}

// Private State class for MapPage, manages state and map interactions
class _MapPage extends State<MapPage> with TickerProviderStateMixin {
  //ignore: unused_field
  final AuthService _authService = AuthService();
  final List<LatLng> _routePoints = [];
  final List<Marker> _marker = [];
  late RouteService _routeService;
  final StopsService _stopsService = StopsService();
  
  late AnimatedMapController _animatedMapController;
  late LatLng? _latestLocation;
  late StreamSubscription<Position>? _locationStream;
  late StreamSubscription<ServiceStatus> _locationStatusStream;
  bool? _locationStatus;

  // Journey state management (tracks whether a journey is currently active)
  bool _journeyActive = false; // false means the journey hasn't started yet, true means it has.

  // User inputs (mileage / MPG)
  double _startMileage = 0;
  double _startMpg = 0;
  double _endMpg = 0;

  // State initialisation 
  @override
  void initState() {
    super.initState();
    _animatedMapController = AnimatedMapController(vsync: this, duration: Duration(milliseconds: 1500));
    _initialiseLocationServices();
    _initialiseLocationStatusStream();
    _initializeEnvAndService();
  }

  void _initialiseLocationStatusStream() async {
    _locationStatus = await Geolocator.isLocationServiceEnabled();
    _locationStatusStream = Geolocator.getServiceStatusStream()
        .listen((ServiceStatus status) {
      setState(() {
        _locationStatus = (status == ServiceStatus.enabled) ? true : false;
      });
    });
  }

  void _initialiseLocationServices() async {
    // Ask user for location permissions
    _latestLocation = null;
    bool locationAccessible = await getLocationPermissions();
    if (locationAccessible) {
      _initialisePositionStream();
    } else {
      locationAccessible = await requestLocationPermissions();
      if (locationAccessible) {
        _initialisePositionStream();
      }
    }
  }

  // Function to initialise location stream.
  // The stream updates the latestLocation variable to new location if the
  // device moves more than 5 metres from the previous latestLocation value.
  void _initialisePositionStream() {
    final LocationSettings locationSettings = LocationSettings(
      distanceFilter: 5, // Minimum distance device must move (in metres) to update the location
    );
    // Create a location stream which returns device location at regular intervals
    _locationStream = Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) {
      setState(() {
        _latestLocation = LatLng(position!.latitude, position.longitude);
      });
    });
  }

  // This function loads .env and initializes RouteService asynchronously
  Future<void> _initializeEnvAndService() async {
    // // Initialize RouteService with API key

    try {
      // Attempt to load the .env file
      await dotenv.load(fileName: '.env');

      // Check if the API key exists in .env; show an error message if not
      final apiKey = dotenv.env['API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception("API key missing in .env file.");
      }
      // Initialize RouteService with the valid API key
      _routeService = RouteService(dotenv.env['API_KEY']!);
      await _drawCompleteRoute();
      await _drawStopsMarker(Colors.blue);

      await _fetchOptimizedRoute();
    } catch (e) {
      // Log the error and provide feedback
      _showErrorDialog("Failed to initialize map service. Please check API key and network connection.");
    }


  }


  // Function to draw a complete route between all stops
  Future<void> _drawCompleteRoute() async {
    // Alternatively store stops list as class attribute
    List<LatLng> stops = await _stopsService.fetchAllStops();
    List<LatLng> route = [];
    for (int i = 0; i < stops.length - 1; i++) {
      final start = stops[i];
      final end = stops[i + 1];
      final routePart = await _routeService.getRoute(start.latitude, start.longitude, end.latitude, end.longitude);
      route.addAll(routePart);
    }
    setState(() {
      _routePoints.clear();
      _routePoints.addAll(route);
    });

  }

  Future<void> _drawStopsMarker( Color color) async {
    List<LatLng> stops = await _stopsService.fetchAllStops();
    for (int i = 0; i < stops.length; i++) {
      _marker.add(MarkerWidget.createMarker(stops[i], color));
    }

  }




  // Fetches route data from the ORS API between the two given stops, entered by their ID.
  // ignore: unused_element
  Future<void> _fetchRoute(int firstStopID,int secondStopID) async {

    LatLng startPoint = await _stopsService.fetchStop(firstStopID);
    LatLng collectionPoint = await _stopsService.fetchStop(secondStopID);



    final startLat = startPoint.latitude, startLng = startPoint.longitude;
    final endLat = collectionPoint.latitude, endLng = collectionPoint.longitude;


    // Get route points from the API and update _routePoints with the data
    final List<LatLng> route = await _routeService.getRoute(startLat, startLng, endLat, endLng);

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
      List<LatLng> optimizedRoute = await _routeService.routePlanning();
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

  /// Shows a dialog when an invalid (non-numeric) value is provided.
  void _showInvalidInputDialog(String fieldLabel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Invalid Input"),
        content: Text("Please enter a valid numeric value for $fieldLabel."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  /// Dialog for starting a journey: asks for mileage and MPG.
  /// After validating the input, it updates the state fields and sets
  /// [_journeyActive] to true.
  void _showStartJourneyDialog() {
    String mileageInput = '';
    String mpgInput = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Start Journey'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Mileage'),
                  onChanged: (value) => mileageInput = value,
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration:
                  const InputDecoration(labelText: 'Miles per Gallon'),
                  onChanged: (value) => mpgInput = value,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss dialog
              },
            ),
            ElevatedButton(
              child: const Text('Confirm'),
              onPressed: () {
                // Parse user inputs
                final parsedMileage = double.tryParse(mileageInput);
                if (parsedMileage == null) {
                  _showInvalidInputDialog('Mileage');
                  return;
                }

                final parsedMpg = double.tryParse(mpgInput);
                if (parsedMpg == null) {
                  _showInvalidInputDialog('Miles per Gallon');
                  return;
                }

                // Valid input: update state
                setState(() {
                  _startMileage = parsedMileage;
                  _startMpg = parsedMpg;
                  _journeyActive = true;
                });

                debugPrint('Start Mileage: $_startMileage');
                debugPrint('Start MPG: $_startMpg');

                Navigator.of(context).pop(); // Dismiss dialog
              },
            ),
          ],
        );
      },
    );
  }

  /// Dialog for ending a journey: asks only for MPG.
  /// After validating, it updates the [_endMpg] field and sets [_journeyActive] to false.
  void _showEndJourneyDialog() {
    String mpgInput = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('End Journey'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Miles per Gallon'),
            onChanged: (value) => mpgInput = value,
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss dialog
              },
            ),
            ElevatedButton(
              child: const Text('Confirm'),
              onPressed: () {
                final parsedMpg = double.tryParse(mpgInput);
                if (parsedMpg == null) {
                  _showInvalidInputDialog('Miles per Gallon');
                  return;
                }

                setState(() {
                  _endMpg = parsedMpg;
                  _journeyActive = false;
                });

                debugPrint('End MPG: $_endMpg');

                Navigator.of(context).pop(); // Dismiss dialog
              },
            ),
          ],
        );
      },
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


      floatingActionButton: RecentreButton(onPressed: () async {
        // If recentre button pressed recentre map over user location
        // Check if location permissions have been granted.
        if (await getLocationPermissions()) {
          if (_latestLocation != null) {
            _animatedMapController.animateTo(
                dest: LatLng(
                    _latestLocation!.latitude, _latestLocation!.longitude),
                zoom: 14);
          }
        } else {
          // Request permission if not already granted.
          if (await requestLocationPermissions()) {
            _initialisePositionStream();
            if (_latestLocation != null) {
              _animatedMapController.animateTo(
                  dest: LatLng(
                      _latestLocation!.latitude, _latestLocation!.longitude),
                  zoom: 14);
            }
          }
        }
      }),
    );
  }


  // Widget that creates and displays map with initial configurations, route and markers
  Widget content() {
    return FlutterMap(
      mapController: _animatedMapController.mapController,
      options: const MapOptions(
        initialCenter: LatLng(51.4492, -2.5879),
        minZoom: 2.5,
        maxZoom: 19,
        initialZoom: 14,
        interactionOptions:
        InteractionOptions(
            flags: ~InteractiveFlag.doubleTapZoom & // Disable double tap to zoom
            ~InteractiveFlag.rotate // Disable map rotation
        ),
      ),
      children: [
        openStreetMapTileLayer, // Adds the OpenStreetMap tile layer to the map
        RoutePolylineLayer(routePoints: _routePoints),
        MarkerLayer(markers: _marker),
        // Only display location marker if app can access location
        if (_locationStatus != null && _latestLocation != null) if (_locationStatus!) LocationMarker(location: _latestLocation!),
      ],
    );
  }

  // Tile layer for OpenStreetMap tiles
  TileLayer get openStreetMapTileLayer => TileLayer(
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
  );

  @override
  void dispose() {
    _locationStream?.cancel();
    _locationStatusStream.cancel();
    super.dispose();
  }
}

