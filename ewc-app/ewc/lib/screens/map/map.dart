import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../services/route-plot-api.dart';

class MapPage extends StatefulWidget{
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPage();
}


class _MapPage extends State<MapPage> {
  final List<LatLng> _routePoints = [];
  late RouteService _routeService;

  // ---- State initialisation ----
  @override
  void initState() {
    super.initState();
    _initializeEnvAndService();

  }

  // This function loads .env and initializes RouteService asynchronously
  Future<void> _initializeEnvAndService() async {
    await dotenv.load(fileName: '.env'); // Load the .env file
    // _routeService = RouteService(dotenv.env['API_KEY']!); // Initialize RouteService with API key
    _routeService = RouteService(dotenv.env['API_KEY']!); // Initialize RouteService with API key
    _fetchRoute();
  }

  // ---- Fetching rout points, data ----
  Future<void> _fetchRoute() async {
    const startLat = 51.4553, startLng = -2.6050;
    const endLat = 51.4492, endLng = -2.5810;

    final List<LatLng> route = await _routeService.getRoute(startLat, startLng, endLat, endLng);

    setState(() {
      _routePoints.clear();
      _routePoints.addAll(route);
    });
  }


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
  Widget content() {
  return FlutterMap(
    options: MapOptions(
      initialCenter: LatLng(51.4492, -2.5879),
      initialZoom: 14,
      interactionOptions:
        const InteractionOptions(flags: ~InteractiveFlag.doubleTapZoom),
    ),
    children: [
      openStreetMapTileLayer,
      PolylineLayer(
        polylines: [
          Polyline(
            points: _routePoints, 
            strokeWidth: 4.0, 
            color: Colors.blue
            ),
        ],
        
      ),
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


TileLayer get openStreetMapTileLayer => TileLayer(
  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
  userAgentPackageName: 'dev.fleaflet.flutter_map.example',
);