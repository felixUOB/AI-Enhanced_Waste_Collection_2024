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
import 'package:ewc/widgets/destination_marker_layer.dart';
import 'package:ewc/widgets/route_polyline_layer.dart';
import 'package:ewc/widgets/recentre_button.dart';

/// MapPage is a stateful widget displaying a map and plotting a route.
class MapPage extends StatefulWidget {
  const MapPage({super.key}); // Uses the super-parameter to pass the key up to the superclass.

  @override
  State<MapPage> createState() => _MapPage(); // Creates the private state class for this widget.
}

/// Private state class for the [MapPage].
/// Manages user input for starting/ending mileage and mpg,
/// loads environment variables, fetches a route, and displays it on a map.
class _MapPage extends State<MapPage> {
  // final AuthService _authService = AuthService(); // AuthService instance to handle authentication logic.
  final List<LatLng> _routePoints = []; // A list of LatLng points that represent the route.
  late RouteService _routeService; // A RouteService instance for fetching route data.

  // Variables to store user input (for future DB operations).
  double _startMileage = 0; // Stores the "start trip" mileage entered by the user.
  double _startMpg = 0; // Stores the "start trip" MPG entered by the user.
  double _endMpg = 0; // Stores the "end trip" MPG entered by the user.

  @override
  void initState() {
    super.initState(); // Calls the superclass initState.
    _initializeEnvAndService(); // Loads .env variables and initializes the route service.
  }

  /// Loads the .env file and initializes [RouteService].
  /// Displays an error dialog if the API key is missing or invalid.
// Private State class for MapPage, manages state and map interactions
class _MapPage extends State<MapPage> with TickerProviderStateMixin {
  // final AuthService _authService = AuthService();
  final List<LatLng> _routePoints = [];
  late RouteService _routeService;

  late LatLng? _latestLocation;
  late StreamSubscription<Position>? _locationStream;
  late StreamSubscription<ServiceStatus> _locationStatusStream;
  bool? _locationStatus;

  late AnimatedMapController _animatedMapController;

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
    try {
      await dotenv.load(fileName: '.env'); // Loads environment variables from the .env file.
      final apiKey = dotenv.env['API_KEY']; // Retrieves the API key from environment variables.

      // Throws an exception if the API key is empty or null.
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception("API key missing in .env file.");
      }
      _routeService = RouteService(dotenv.env['API_KEY']!); // Creates the RouteService with the valid API key.
      await _fetchRoute(); // Fetches the default route points from the API.
    } catch (e) {
      // Shows an error dialog if initialization fails.
      _showErrorDialog(
          "Failed to initialize map service. Please check the API key and network connection."
      );
    }
  }

  /// Fetches route data from the API and updates [_routePoints].
  Future<void> _fetchRoute() async {
    // Hard-coded coordinates for the start and end locations.
    const startLat = 51.4553, startLng = -2.6050;
    const endLat = 51.4492, endLng = -2.5810;

    // Uses the RouteService to retrieve a list of LatLng route points.
    final List<LatLng> route =
    await _routeService.getRoute(startLat, startLng, endLat, endLng);

    setState(() {
      // Remove any existing points
      _routePoints.clear();
      // Add new route points
      _routePoints.addAll(route);
    });
  }

  /// Displays a generic error dialog with a given [message].
  void _showErrorDialog(String message) {
    showDialog(
      context: context, // Uses the current BuildContext for display.
      builder: (context) => AlertDialog(
        title: const Text("Error"), // Dialog title.
        content: Text(message), // Displays the error message passed in.
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Closes the dialog.
            child: const Text("OK"), // Button label.
          ),
        ],
      ),
    );
  }

  /// Displays a dialog indicating an invalid numeric input for a particular field.
  void _showInvalidInputDialog(String fieldLabel) {
    showDialog(
      context: context, // Uses the current BuildContext for display.
      builder: (context) => AlertDialog(
        title: const Text("Invalid Input"), // Dialog title.
        // Displays which field had invalid input.
        content: Text("Please enter a valid numeric value for $fieldLabel."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // Closes the dialog.
            child: const Text("OK"), // Button label.
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final navigator = Navigator.of(context); // A reference to the current Navigator.

    // Builds the main UI layout with an AppBar, body content, and a bottom navigation bar.
    return Scaffold(
      body: _buildMapContent(), // The main map content is built in a separate method.
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Spacing around the buttons.
        child: Row(
          children: [
            // "Start Trip" button
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  _showStartDialog(); // Opens the dialog for starting a trip.
                },
                child: const Text('Start Trip'), // Button label.
              ),
            ),
            const SizedBox(width: 16.0), // Spacing between the two buttons.
            // "End Trip" button
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red), // Red background.
                onPressed: () async {
                  _showEndDialog(); // Opens the dialog for ending a trip.
                },
                child: const Text('End Trip'), // Button label.
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
      body: content(),
    );
  }

  /// Builds the main map UI, including tile layers and route markers.
  Widget _buildMapContent() {
    return FlutterMap(
      mapController: _animatedMapController.mapController,
      options: const MapOptions(
        initialCenter: LatLng(51.4492, -2.5879), // Map's initial center point (Latitude, Longitude).
        initialZoom: 14, // Map's initial zoom level.
        interactionOptions: InteractionOptions(flags: ~InteractiveFlag.doubleTapZoom),
        // Disables double-tap-to-zoom behavior.
      ),
      children: [
        _openStreetMapTileLayer, // The base map tile layer from OpenStreetMap.
        RoutePolylineLayer(routePoints: _routePoints), // Custom layer that draws a polyline for the route.
        DestinationMarker(location: LatLng(51.4516, -2.5810)), // Custom layer that marks a specific destination.
      ],
    );
  }

  /// Displays a dialog to enter mileage and MPG when starting a trip.
  void _showStartDialog() {
    String mileageInput = ''; // Temporary holder for mileage input.
    String mpgInput = ''; // Temporary holder for MPG input.

    showDialog(
      context: context, // Current BuildContext for this widget.
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Start Journey'), // Dialog title.
          content: SingleChildScrollView(
            // Allows scrolling if the content is too long.
            child: ListBody(
              // A column-like widget for the text fields.
              children: [
                TextField(
                  keyboardType: TextInputType.number, // Numeric keyboard.
                  decoration: const InputDecoration(labelText: 'Mileage'), // TextField label.
                  onChanged: (value) => mileageInput = value, // Updates local variable on change.
                ),
                TextField(
                  keyboardType: TextInputType.number, // Numeric keyboard.
                  decoration: const InputDecoration(labelText: 'Miles per Gallon'), // TextField label.
                  onChanged: (value) => mpgInput = value, // Updates local variable on change.
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Closes the dialog without saving.
              },
            ),
            ElevatedButton(
              child: const Text('Confirm'),
              onPressed: () {
                // Attempts to parse mileage
                final parsedMileage = double.tryParse(mileageInput);
                if (parsedMileage == null) {
                  _showInvalidInputDialog('Mileage'); // Show error if invalid.
                  return; // Remain in the dialog to correct input.
                }

                // Attempts to parse MPG
                final parsedMpg = double.tryParse(mpgInput);
                if (parsedMpg == null) {
                  _showInvalidInputDialog('Miles per Gallon'); // Show error if invalid.
                  return; // Remain in the dialog to correct input.
                }

                // If both are valid, update the state variables.
                setState(() {
                  _startMileage = parsedMileage;
                  _startMpg = parsedMpg;
                });

                // Debug logs
                print('Start Mileage: $_startMileage');
                print('Start MPG: $_startMpg');

                Navigator.of(context).pop(); // Closes the dialog after saving.
                // Additional logic for database or state updates can be placed here.
              },
            ),
          ],
        );
      },
    );
  }

  /// Displays a dialog to enter MPG when ending a trip.
  void _showEndDialog() {
    String mpgInput = ''; // Temporary holder for end-trip MPG input.

    showDialog(
      context: context, // Current BuildContext.
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('End Journey'), // Dialog title.
          content: TextField(
            keyboardType: TextInputType.number, // Numeric keyboard.
            decoration: const InputDecoration(labelText: 'Miles per Gallon'), // TextField label.
            onChanged: (value) => mpgInput = value, // Updates local variable on change.
          ),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Closes the dialog without saving.
              },
            ),
            ElevatedButton(
              child: const Text('Confirm'),
              onPressed: () {
                final parsedMpg = double.tryParse(mpgInput);
                if (parsedMpg == null) {
                  _showInvalidInputDialog('Miles per Gallon'); // Show error if invalid.
                  return; // Remain in the dialog to correct input.
                }

                setState(() {
                  _endMpg = parsedMpg; // If valid, update the end-trip MPG state variable.
                });

                // Debug logs
                print('End MPG: $_endMpg');

                Navigator.of(context).pop(); // Closes the dialog after saving.
                // Additional logic for database or state updates can be placed here.
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
    // Template URL for fetching OSM map tiles.
    userAgentPackageName: 'dev.fleaflet.flutter_map.example',
    // Provides a User-Agent for tile usage analytics.
  );
}
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

