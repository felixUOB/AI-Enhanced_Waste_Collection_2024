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
import 'package:ewc/models/stop_model.dart';
import 'package:ewc/widgets/recentre_button.dart';
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
    Provider.of<LocationProvider>(context, listen: false).initialiseLocationServices();
    _initialiseLocationStatusStream();
    _initializeEnvAndService();
  }

  void _initialiseLocationStatusStream() async {
    _locationStatus = await Geolocator.isLocationServiceEnabled();
    _locationStatusStream = Geolocator.getServiceStatusStream()
        .listen((ServiceStatus status) {
      setState(() {
        _locationStatus = status == ServiceStatus.enabled;
      });
    });
  }

  // This function loads .env and initializes RouteService asynchronously
  Future<void> _initializeEnvAndService() async {
    try {
      _stops = await _stopsService.fetchAllStops();
      // Initialize RouteService with API key

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

    } catch (e) {
      // Log the error and provide feedback
      _showErrorDialog("Failed to initialize map service. Please check API key and network connection.");
    }


  }


  // Function to draw a complete route between all stops
  Future<void> _drawCompleteRoute() async {
    // Alternatively store stops list as class attribute
    List<LatLng> route = [];
    for (int i = 0; i < _stops.length - 1; i++) {
      final start = _stops[i];
      final end = _stops[i + 1];
      final routePart = await _routeService.getRoute(
          start.location.latitude, start.location.longitude,
          end.location.latitude, end.location.longitude
      );
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          //ZOOM IN
          FloatingActionButton(
            heroTag: "zoom in",
            child: const Icon(Icons.add),
            onPressed: () {
              _animatedMapController.animatedZoomIn(duration: Duration(milliseconds: 500));

            },
        ),
        const SizedBox(height: 10), // Space between buttons
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
        }// Space for recentre button
        )
        ])
    );
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
        if (_locationStatus != null && location != null)
          if (_locationStatus!) LocationMarker(location: location),
      ],
    );
  }

  // Tile layer for OpenStreetMap tiles
  TileLayer get openStreetMapTileLayer => TileLayer(
    urlTemplate: 'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
    subdomains: ['a','b','c'],
    retinaMode: RetinaMode.isHighDensity(context),
    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
  );

  @override
  void dispose() {
    _locationStatusStream.cancel();
    super.dispose();
  }
}

