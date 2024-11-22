import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../services/route-plot-api.dart';
import 'package:ewc/widgets/destination_marker_layer.dart';
import 'package:ewc/widgets/route_polyline_layer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// MapPage is a stateful widget displaying a map and plotting a route
class MapPage extends StatefulWidget{
  const MapPage({super.key});

  // Creates and returns the private _MapPage state instance to manage the widget's state
  @override
  State<MapPage> createState() => _MapPage();
}

// Private State class for MapPage, manages state and map interactions
class _MapPage extends State<MapPage> {
  final List<LatLng> _routePoints = [];
  late RouteService _routeService;

  // State initialisation 
  @override
  void initState() {
    super.initState();
    _initializeEnvAndService();

  }
  // Retrieve latitude and longitude of a collection point by its id
  Future<LatLng> _getCollectionPoint(int collection_point_id) async {
    final url = 'http://127.0.0.1:8000/api/collection_points/$collection_point_id';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final lat = data['latitude'];
      final lng = data['longitude'];
      return LatLng(lat, lng);
    } else {
      throw Exception('Failed to load collection point');
    }
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
      print("Error initializing environment and service: $e Failed to initialize map service. Please check API key");
      _showErrorDialog("Failed to initialize map service. Please check API key and network connection.");
    }


  }

  // Fetches route data from the API
  Future<void> _fetchRoute() async {
    const startLat = 51.4553, startLng = -2.6050;
    const endLat = 51.4492, endLng = -2.5810;

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
    return Scaffold(
      appBar: AppBar(title: const Text('RecycleNXT',
      style:TextStyle(fontFamily: 'Questrial', fontSize: 22),
      ),
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