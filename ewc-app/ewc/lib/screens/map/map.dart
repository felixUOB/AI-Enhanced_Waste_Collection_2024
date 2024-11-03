import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../services/route-plot-api.dart';
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

  // This function loads .env and initializes RouteService asynchronously
  Future<void> _initializeEnvAndService() async {
    await dotenv.load(fileName: '.env'); // Load the .env file
    // Initialize RouteService with API key
    _routeService = RouteService(dotenv.env['API_KEY']!);
    _fetchRoute();
  }

  // Fetches rout data from the API
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


  // Builds the main UI for the map screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('RecycleNXT',
      style:TextStyle(fontFamily: 'Questrial', fontSize: 22),
      ),
      ),
      body: content(),
    );
  }


  // Widget that creates and displays map with initial configurations, route and markers
  Widget content() {
  return FlutterMap(
    options: MapOptions(
      initialCenter: LatLng(51.4492, -2.5879),
      initialZoom: 14,
      interactionOptions:
        const InteractionOptions(flags: ~InteractiveFlag.doubleTapZoom),
    ),
    children: [
      // Adds the OpenStreetMap tile layer to the map
      openStreetMapTileLayer,
      
      // Layer to display the route between route points fetched from API
      PolylineLayer(
        polylines: [
          Polyline(
            points: _routePoints, 
            strokeWidth: 4.0, 
            color: Colors.blue
            ),
        ],
        
      ),
      
      // Layer to display a marker on the map
      MarkerLayer(markers: [
        Marker(
          point: LatLng(51.4516, -2.5810),
          width: 60,
          height: 60,
          alignment: Alignment.bottomCenter,
          child: Icon(
            Icons.location_pin,
            size:60,
            color: Colors.red,

        )),
      ])
    ],
  );
}
}

// Tile layer for OpenStreetMap tiles
TileLayer get openStreetMapTileLayer => TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
);