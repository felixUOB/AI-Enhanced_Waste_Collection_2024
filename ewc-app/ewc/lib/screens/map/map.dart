import 'dart:async';
import 'package:ewc/services/location_service.dart';
import 'package:ewc/widgets/location_marker.dart';
import 'package:flutter/material.dart';
import 'package:ewc/widgets/theme_switch.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../services/route_plot_api.dart';
import 'package:ewc/widgets/destination_marker_layer.dart';
import 'package:ewc/widgets/route_polyline_layer.dart';
import '../../widgets/recentre_button.dart';

// MapPage is a stateful widget displaying a map and plotting a route
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  // Creates and returns the private _MapPage state instance to manage the widget's state
  @override
  State<MapPage> createState() => _MapPage();
}

// Private State class for MapPage, manages state and map interactions
class _MapPage extends State<MapPage> with TickerProviderStateMixin {
  final List<LatLng> _routePoints = [];
  late RouteService _routeService;

  late LatLng? _latestLocation;
  late StreamSubscription<Position> _locationStream;

  late AnimatedMapController _animatedMapController;

  // State initialisation
  @override
  void initState() {
    super.initState();
    _animatedMapController = AnimatedMapController(vsync: this);
    _initialiseLocationServices();
    _initializeEnvAndService();
  }

  void _initialiseLocationServices() async {
    // Ask user for location permissions
    _latestLocation = null;
    bool locationAccessible = await getLocationPermissions();
    if (locationAccessible) {
      initialiseStream();
    } else {
      locationAccessible = await requestLocationPermissions();
      if (locationAccessible) {
        initialiseStream();
      }
    }
  }

  // Function to initialise location stream.
  // The stream updates the latestLocation variable to new location if the
  // device moves more than 5 metres from the previous latestLocation value.
  void initialiseStream() {
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
    // await dotenv.load(fileName: '.env'); // Load the .env file
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
      await _fetchRoute();
    } catch (e) {
      // Log the error and provide feedback
      _showErrorDialog(
          "Failed to initialize map service. Please check API key and network connection.");
    }
  }

  // Fetches route data from the API
  Future<void> _fetchRoute() async {
    const startLat = 51.4553, startLng = -2.6050;
    const endLat = 51.4492, endLng = -2.5810;

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
      appBar: AppBar(
        //toolbarHeight: 75,
        title:
          Text('RecycleNXT', style: Theme.of(context).textTheme.titleLarge),
        //style: TextStyle(fontFamily: 'Questrial', fontSize: 32))
        actions: [
          SafeArea(
            child: Container(
              // ignore: prefer_const_literals_to_create_immutables
              margin: EdgeInsets.only(right: 8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(3),
                    child:
                        // ignore: prefer_const_constructors
                        Align(
                      alignment: Alignment.topRight,
                      // ignore: prefer_const_constructors
                      child: ThemeSwitch(),
                    ))
                ],
              )
            )
          ) // ignore: prefer_const_constructor
        ],
      ),
      floatingActionButton: RecentreButton(onPressed: () async {
        // If recentre button pressed recentre map over user location
        // Check if location permissions have been granted.
        if (await getLocationPermissions()) {
          _animatedMapController.animateTo(
              dest: LatLng(_latestLocation!.latitude, _latestLocation!.longitude), zoom: 14);
        } else {
          // Request permission if not already granted.
          if (await requestLocationPermissions()) {
            initialiseStream();
            _animatedMapController.animateTo(
                dest: LatLng(_latestLocation!.latitude, _latestLocation!.longitude), zoom: 14);
          }
        }
      }),
      body: content(),
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
        DestinationMarker(location: LatLng(51.4516, -2.5810)),
        // Only display location marker if app can access location
        if (_latestLocation != null) LocationMarker(location: _latestLocation!),
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
    _locationStream.cancel();
    super.dispose();
  }
}
