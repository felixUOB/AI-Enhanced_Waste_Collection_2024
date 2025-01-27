import 'package:ewc/services/auth_service.dart';
import 'package:ewc/screens/splash/splash.dart';
import 'package:ewc/widgets/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:ewc/widgets/theme_switch.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ewc/services/route_plot_service.dart';
import 'package:ewc/widgets/destination_marker_layer.dart';
import 'package:ewc/widgets/route_polyline_layer.dart';
import 'dart:convert';


// MapPage is a stateful widget displaying a map and plotting a route
class MapPage extends StatefulWidget {
  const MapPage({super.key});

  // Creates and returns the private _MapPage state instance to manage the widget's state
  @override
  State<MapPage> createState() => _MapPage();
}

// Private State class for MapPage, manages state and map interactions
class _MapPage extends State<MapPage> {
  final AuthService _authService = AuthService();
  final List<LatLng> _routePoints = [];
  late RouteService _routeService;

  // State initialisation 
  @override
  void initState() {
    super.initState();
    _initializeEnvAndService();

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

    } catch (e) {
      // Log the error and provide feedback
      _showErrorDialog("Failed to initialize map service. Please check API key and network connection.");
    }


  }

  //NEW FUNCTION GETS ROUTE DATA FROM API 
  Future<LatLng> fetchStop(int collectionPointID) async {

    final authService = AuthService();
    final response = await authService.makeAuthenticatedRequest('stops/$collectionPointID');


    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final lat = data['latitude'];
      final lng = data['longitude'];
      return LatLng(lat, lng);
    } else {
      throw Exception('Failed to load collection point');
    }
  }

  
  // Fetches all collection points from the API and returns a list of LatLng
  Future<List<LatLng>> fetchAllStops() async {
    final authService = AuthService();
    final response = await authService.makeAuthenticatedRequest('stops');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List;
      List<LatLng> latLngStopsList = [];
      for (var point in data) {
        latLngStopsList.add(LatLng(point['latitude'], point['longitude']));
      }
      return data.map((point) => LatLng(point['latitude'], point['longitude'])).toList();
    } else {
      throw Exception('Failed to load collection points');
    }
  }

  // Function to draw a complete route between all stops
  Future<void> _drawCompleteRoute() async {
    // Alternatively store stops list as class attribute
    List<LatLng> stops = await fetchAllStops();
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



  // Fetches route data from the API
  // ignore: unused_element
  Future<void> _fetchRoute() async {

    LatLng startPoint = await fetchStop(2);
    LatLng collectionPoint = await fetchStop(3);



    final startLat = startPoint.latitude, startLng = startPoint.longitude;
    final endLat = collectionPoint.latitude, endLng = collectionPoint.longitude;

    debugPrint('Start: $startLat, $startLng');
    debugPrint('Collection Point: $collectionPoint');

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




  // Builds the main UI for the map screen
  @override
  Widget build(BuildContext context) {
    NavigatorState navigator = Navigator.of(context);
    
    return Scaffold(

      appBar: AppBar(
        leading: LogoutButton(
            iconData: Icons.logout,
            onPressed: () {
              _authService.clearCredentials();
              navigator.pushReplacement(
                MaterialPageRoute(
                  builder: (context) => SplashPage(), // Moving pages
                ),
              );
            }),
        //toolbarHeight: 75,
        title: Text('RecycleNXT',
            style: Theme.of(context).textTheme.titleLarge),
            //style: TextStyle(fontFamily: 'Questrial', fontSize: 32))
        actions: [
          SafeArea(
            child: Align(
                  alignment: Alignment.topRight,
                  // ignore: prefer_const_constructors
                  child: Padding(
                      padding: EdgeInsets.zero,
                      child:
                          ThemeSwitch()))) // ignore: prefer_const_constructor
        ],
                    
            
      ),
      body: content(),
    );
  }


  // Widget that creates and displays map with initial configurations, route and markers
  Widget content() {
  return FlutterMap(
    options: const MapOptions(
      initialCenter: LatLng(51.4492, -2.5879),
      initialZoom: 14,
      interactionOptions:
        InteractionOptions(flags: ~InteractiveFlag.doubleTapZoom),
    ),
    
    children: [
      openStreetMapTileLayer, // Adds the OpenStreetMap tile layer to the map
      RoutePolylineLayer(routePoints : _routePoints),
      DestinationMarker(location: LatLng(51.4516, -2.5810)),
    

    ],
    
  );
}


  // Tile layer for OpenStreetMap tiles
  TileLayer get openStreetMapTileLayer => TileLayer(
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
  );



}