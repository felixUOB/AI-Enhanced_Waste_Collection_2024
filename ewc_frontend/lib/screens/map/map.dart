import 'package:ewc/services/auth_service.dart';
import 'package:ewc/screens/splash/splash.dart';
import 'package:ewc/widgets/logout_button.dart';
import 'package:flutter/material.dart';
import 'package:ewc/widgets/theme_switch.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../services/route_plot_service.dart';
import 'package:ewc/widgets/destination_marker_layer.dart';
import 'package:ewc/widgets/route_polyline_layer.dart';

/// A stateful widget that displays a map and manages route plotting.
class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPage();
}

/// Private state class for the [MapPage].
/// Manages user input for starting/ending mileage and mpg,
/// loads environment variables, fetches a route, and displays it on a map.
class _MapPage extends State<MapPage> {
  final AuthService _authService = AuthService();
  final List<LatLng> _routePoints = [];
  late RouteService _routeService;

  // Variables to store user input (to be used for future DB operations)
  double _startMileage = 0;
  double _startMpg = 0;
  double _endMpg = 0;

  @override
  void initState() {
    super.initState();
    _initializeEnvAndService();
  }

  /// Loads the .env file and initializes the [RouteService] asynchronously.
  /// Displays an error dialog if the API key is missing or invalid.
  Future<void> _initializeEnvAndService() async {
    try {
      await dotenv.load(fileName: '.env');
      final apiKey = dotenv.env['API_KEY'];

      if (apiKey == null || apiKey.isEmpty) {
        throw Exception("API key missing in .env file.");
      }

      _routeService = RouteService(apiKey);
      await _fetchRoute();
    } catch (e) {
      _showErrorDialog(
          "Failed to initialize map service. Please check the API key and network connection."
      );
    }
  }

  /// Fetches route data from the API and updates [_routePoints].
  Future<void> _fetchRoute() async {
    const startLat = 51.4553, startLng = -2.6050;
    const endLat = 51.4492, endLng = -2.5810;

    final List<LatLng> route =
    await _routeService.getRoute(startLat, startLng, endLat, endLng);

    setState(() {
      _routePoints.clear();
      _routePoints.addAll(route);
    });
  }

  /// Displays a generic error dialog with the provided [message].
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  /// Displays a dialog indicating an invalid numeric input for a particular field.
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

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: LogoutButton(
          iconData: Icons.logout,
          onPressed: () {
            _authService.clearCredentials();
            navigator.pushReplacement(
              MaterialPageRoute(
                builder: (context) => const SplashPage(),
              ),
            );
          },
        ),
        title: Text(
          'RecycleNXT',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: [
          SafeArea(
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: EdgeInsets.zero,
                child: const ThemeSwitch(),
              ),
            ),
          ),
        ],
      ),
      body: _buildMapContent(),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            // Start Trip Button
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  _showStartDialog();
                },
                child: const Text('Start Trip'),
              ),
            ),
            const SizedBox(width: 16.0),
            // End Trip Button
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                ),
                onPressed: () async {
                  _showEndDialog();
                },
                child: const Text('End Trip'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the main map UI, including tile layers and route markers.
  Widget _buildMapContent() {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(51.4492, -2.5879),
        initialZoom: 14,
        interactionOptions:
        InteractionOptions(flags: ~InteractiveFlag.doubleTapZoom),
      ),
      children: [
        _openStreetMapTileLayer,
        RoutePolylineLayer(routePoints: _routePoints),
        DestinationMarker(location: LatLng(51.4516, -2.5810)),
      ],
    );
  }

  /// Displays a dialog to enter mileage and MPG when starting a trip.
  void _showStartDialog() {
    String mileageInput = '';
    String mpgInput = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Start Trip'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Mileage',
                  ),
                  onChanged: (value) {
                    mileageInput = value;
                  },
                ),
                TextField(
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Miles per Gallon',
                  ),
                  onChanged: (value) {
                    mpgInput = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            ElevatedButton(
              child: const Text('Confirm'),
              onPressed: () {
                // Attempt to parse mileage
                final parsedMileage = double.tryParse(mileageInput);
                if (parsedMileage == null) {
                  _showInvalidInputDialog('Mileage');
                  return; // Remain in dialog
                }

                // Attempt to parse MPG
                final parsedMpg = double.tryParse(mpgInput);
                if (parsedMpg == null) {
                  _showInvalidInputDialog('Miles per Gallon');
                  return; // Remain in dialog
                }

                setState(() {
                  _startMileage = parsedMileage;
                  _startMpg = parsedMpg;
                });

                // Debug logs
                print('Start Mileage: $_startMileage');
                print('Start MPG: $_startMpg');

                Navigator.of(context).pop(); // Close the dialog
                // Additional logic for DB or state updates can be added here
              },
            ),
          ],
        );
      },
    );
  }

  /// Displays a dialog to enter MPG when ending a trip.
  void _showEndDialog() {
    String mpgInput = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('End Trip'),
          content: TextField(
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Miles per Gallon',
            ),
            onChanged: (value) {
              mpgInput = value;
            },
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            ElevatedButton(
              child: const Text('Confirm'),
              onPressed: () {
                final parsedMpg = double.tryParse(mpgInput);
                if (parsedMpg == null) {
                  _showInvalidInputDialog('Miles per Gallon');
                  return; // Remain in dialog
                }

                setState(() {
                  _endMpg = parsedMpg;
                });

                print('End MPG: $_endMpg');

                Navigator.of(context).pop(); // Close the dialog
                // Additional logic for DB or state updates can be added here
              },
            ),
          ],
        );
      },
    );
  }

  /// A tile layer for OpenStreetMap base tiles.
  TileLayer get _openStreetMapTileLayer => TileLayer(
    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
  );
}