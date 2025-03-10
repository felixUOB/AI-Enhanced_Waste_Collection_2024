import 'dart:async';
import 'dart:math';
import 'package:ewc/service_locator.dart';
import 'package:ewc/notifiers/stops_notifier.dart';
import 'package:ewc/services/location_service.dart';
import 'package:ewc/services/route_service.dart';
import 'package:ewc/widgets/location_marker.dart';
import 'package:ewc/widgets/log_stop_dialog.dart';
import 'package:ewc/widgets/orientate_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:ewc/widgets/route_polyline_layer.dart';
import 'package:ewc/widgets/marker_widget.dart';
import 'package:ewc/services/stops_service.dart';
import 'package:ewc/models/stop_model.dart';
import 'package:ewc/widgets/recentre_button.dart';
import 'package:ewc/widgets/start_journey_dialog.dart';
import 'package:ewc/widgets/end_journey_dialog.dart';
import 'package:provider/provider.dart';
import 'package:ewc/notifiers/location_notifier.dart';
import 'package:ewc/widgets/navigation_banner.dart';

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
  final Map<List<double>, String> _routeInstructions = {};
  final List<Marker> _marker = [];
  final RouteService _routeService = getIt<RouteService>();
  final StopsService _stopsService = getIt<StopsService>();

  // _closestIndex refers to the routePoint index which the user is currently closest to
  int _closestIndex = 0;

  double _autoBearing = 0; // Bearing set automatically by navigation view
  double _savedBearing = -45; // Bearing set by user rotating map
  bool _lockedNorth = true; // Whether map rotation is locked to the north

  // Location variables
  late AnimatedMapController _animatedMapController;
  late StreamSubscription<ServiceStatus> _locationStatusStream;
  bool? _locationStatus;

  // Journey state management (tracks whether a journey is currently active)
  bool _journeyActive = false; // false means the journey hasn't started yet, true means it has.
  bool _automaticRecentre = false; // True when user has centred on location, meaning camera should follow

  // User inputs (mileage / MPG)
  double _startMileage = 0;
  double _startMpg = 0;
  double _endMpg = 0;

  // State initialisation
  @override
  void initState() {
    super.initState();
    _animatedMapController = AnimatedMapController(vsync: this, duration: Duration(milliseconds: 1500));
    _initialiseLocationStatusStream();
    _initializeEnvAndService();
    Provider.of<LocationProvider>(context, listen: false).addListener(findNearestRoutePoint);
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
      if (mounted) await Provider.of<StopsProvider>(context, listen: false).initialiseStops();
      if (mounted) await Provider.of<LocationProvider>(context, listen: false).initialiseLocationServices();
      await _drawStopsMarker(Colors.blue);
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
    List<Stop> stops = Provider.of<StopsProvider>(context, listen: false).stops;
    for (int i = 0; i < stops.length - 1; i++) {
      final start = stops[i];
      final end = stops[i + 1];
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
    List<Stop> stops = Provider.of<StopsProvider>(context, listen: false).stops;
    for (int i = 0; i < stops.length; i++) {
      _marker.add(MarkerWidget.createMarker(stops[i].location, color));
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
      List<Stop> stops = Provider.of<StopsProvider>(context, listen: false).stops;
      LatLng? location = Provider.of<LocationProvider>(context, listen: false).latestLocation;
      if (location != null) {
        RouteResult result = await _routeService.routePlanning(location, stops);
        List<LatLng> optimizedRoute = result.routeCoordinates;
        Map<List<double>, String> instructionsMap = result.instructionsMap;
        setState(() {
          _routePoints.clear();
          _routeInstructions.clear();
          _routePoints.addAll(optimizedRoute);
          _routeInstructions.addAll(instructionsMap);
        });
      }
    } catch (e) {
      _showErrorDialog("Failed to calculate viable route. Are all stops accessible by car from your location?", _fetchOptimizedRoute);
    }
  }

  // Displays an error dialog with the provided message
  void _showErrorDialog(String message, [Function()? retryFunction]) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error"),
        content: Text(message),
        actions: [
          // Optional retry button
          if (retryFunction != null)
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                retryFunction();
              },
              child: Text("Retry"),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("OK"),
          ),
        ],
      ),
    );
  }

  // This function manages map events
  void _eventManager(MapEvent event) {
    if (event is MapEventMoveStart) {
      if (_automaticRecentre) {
        setState(() {
          _automaticRecentre = false;
        });
      }
    }
    else if (event is MapEventRotateStart) {
      setState(() {
        _automaticRecentre = false;
        _lockedNorth = false;
      });
    }
  }

  // To be used later with the users location - for modification
  List<double>? getInstructionRangeKey(int userIndex) {
    // Find the first instruction range that the user's index falls within the defined range.
    List<double>? activeRange;
    _routeInstructions.forEach((range, instruction) {
      final start = range[0].toInt();
      final end = range[1].toInt();
      if (userIndex >= start && userIndex <= end) {
        activeRange = range;
      }
  });

  // Return the range (key) if found
  return activeRange;
}

  // Builds the main UI for the map screen
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: content()),
          // Overlay the NavigationBanner at the top of the map
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: NavigationBanner(
              visible: _journeyActive,
              instruction: _routeInstructions.values.length > 1
                          ? _routeInstructions.values.elementAt(1)
                          : "No instructions available",
            ),
          ),
          Positioned(
            left: 12.0,
            right: 12.0,
            bottom: 8.0,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: _journeyActive ? Colors.red : Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
              child: Text(
                _journeyActive ? 'End Journey' : 'Start Journey',
                style: const TextStyle(color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,),
              ),
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 56.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            (_journeyActive) ?
            // Log visit button
            FloatingActionButton(
              key: Key("log visit"),
              heroTag: "log visit",
              child: const Icon(Icons.where_to_vote),
              onPressed: () {
                LogStopDialog.show(context,
                  (int stopID, int wasteCollected) {
                    _stopsService.postStopCollection(stopID, wasteCollected);
                    Provider.of<StopsProvider>(context, listen: false).setVisited(stopID);
                  }
                );
              },
            ) : const SizedBox(),
            (_journeyActive) ?
            const SizedBox(height: 10) : const SizedBox(),

            OrientateButton(
              key: Key("orientate button"),
              north: _lockedNorth,
              onPressed: () {
                if (_lockedNorth) {
                  // If user is already orientated north, check if the journey is active
                  // If it is then rotate the map to the according to the bearing
                  // between closest route points. If not rotate camera according to the
                  // previously saved bearing.
                  if (_journeyActive && _automaticRecentre) {
                    _animatedMapController.animatedRotateTo(_autoBearing);
                  } else {
                    _animatedMapController.animatedRotateTo(_savedBearing);
                  }
                  setState(() {
                    // Toggle lockedNorth value
                    _lockedNorth = !_lockedNorth;
                  });
                } else {
                  // User is not already locked north, therefore reset bearing to 0
                  double savedBearing =
                      _animatedMapController.rotation; // Remember current bearing
                  _animatedMapController.animatedRotateReset(); // Reset bearing
                  setState(() {
                    _savedBearing = savedBearing;
                    _lockedNorth = !_lockedNorth;
                  });
                }
              }
            ),
            const SizedBox(height: 10),

            // ZOOM IN
            FloatingActionButton(
              key: Key("zoom in"),
              heroTag: "zoom in",
              child: const Icon(Icons.add),
              onPressed: () {
                _animatedMapController.animatedZoomIn(
                    duration: Duration(milliseconds: 500));
              },
            ),
            const SizedBox(height: 10), // Space between buttons

            // ZOOM OUT
            FloatingActionButton(
              key: Key("zoom out"),
              heroTag: "zoom out",
              child: const Icon(Icons.remove),
              onPressed: () {
                _animatedMapController.animatedZoomOut(duration: Duration(milliseconds: 500));
              },
            ),
            const SizedBox(height: 10),

            RecentreButton(
              key: Key("recentre button"),
              centred: _automaticRecentre,
              onPressed: () async {
                // If recentre button pressed recentre map over user location
                // Check if location permissions have been granted.
                double zoom;
                // Set zoom to higher value if journey is currently active
                _journeyActive ? zoom = 17 : zoom = 14;
                // If recentre button pressed recentre map over user location
                // Check if location permissions have been granted.
                if (await getLocationPermissions()) {
                  if (context.mounted) {
                    Provider.of<LocationProvider>(context, listen: false).initialisePositionStream();
                    LatLng? location = Provider.of<LocationProvider>(context, listen: false).latestLocation;
                    if (location != null) {
                      _animatedMapController.animateTo(
                          dest: location,
                          zoom: zoom);

                      // Enable automatic following of location after user recentres
                      setState(() {
                        _automaticRecentre = true;
                      });
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
                            zoom: zoom);

                        // Enable automatic following of location after user recentres
                        setState(() {
                          _automaticRecentre = true;
                        });
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
              }
            )
          ]
        )
      )
    );
  }

  // Widget that creates and displays map with initial configurations, route and markers
  Widget content() {
    LatLng? location =
        Provider.of<LocationProvider>(context).latestLocation;
    if (_journeyActive && _automaticRecentre) {
      double bearing = _autoBearing;
      if (_lockedNorth) bearing = 0;
      _animatedMapController.animateTo(dest: location, zoom: 17, rotation: bearing);
    }

    return FlutterMap(
      mapController: _animatedMapController.mapController,
      options: MapOptions(
        initialCenter: const LatLng(51.4492, -2.5879),
        minZoom: 2.5,
        maxZoom: 19,
        initialZoom: 14,
        interactionOptions:
        const InteractionOptions(
          enableMultiFingerGestureRace: true,
          flags: ~InteractiveFlag.doubleTapZoom // Disable double tap to zoom
        ),

        onMapEvent: _eventManager, // delegates map events to the event manager
      ),
      children: [
        if (!getIt<Config>().inTestMode) openStreetMapTileLayer, // Adds the OpenStreetMap tile layer to the map
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

  void _showStartJourneyDialog() {
    StartJourneyDialog.show(context, (double mileage, double mpg) {
      // Start tracking distance travelled as journey is now active
      Provider.of<LocationProvider>(context, listen: false).setTracking(true);
      setState(() {
        _startMileage = mileage;
        _startMpg = mpg;
        _journeyActive = true;
        _automaticRecentre = true;
      });
      debugPrint('Start Mileage: $_startMileage, Start MPG: $_startMpg');
    });
    debugPrint('Start Mileage: $_startMileage, Start MPG: $_startMpg');
  }

  void _showEndJourneyDialog() {
    EndJourneyDialog.show(context, (double mpg) {
      // Stop tracking distance travelled as journey has been stopped
      Provider.of<LocationProvider>(context, listen: false).setTracking(false);
      setState(() {
        _endMpg = mpg;
        _journeyActive = false;
      });

      debugPrint('End MPG: $_endMpg');
    });
  }

  // This function finds the nearest point to on the route to the user's location
  // If the distance to the nearest point > rerouteThreshold then the route is recalculated
  // It also calculates the correct bearing for the camera
  Future<void> findNearestRoutePoint() async {
    double minDistance = double.infinity;
    int index = 0;

    if (_routePoints.isEmpty) {
      // Route not yet defined so request new route
      await _fetchOptimizedRoute();
    }

    LatLng? location;
    if (mounted) location = Provider.of<LocationProvider>(context, listen: false).latestLocation;
    if (location == null) {
      // Location not defined yet so exit function
      return;
    }

    // Find new closest route point by searching 3 behind and 6 in front
    // of the previous closest index
    for (int i = max(0, _closestIndex-3); i <
        min(_routePoints.length-1, _closestIndex+6); i++) {

      double newDistance = Geolocator.distanceBetween(
        location.latitude,
        location.longitude,
        _routePoints[i].latitude,
        _routePoints[i].longitude
      );

      if (newDistance < minDistance) {
        minDistance = newDistance;
        index = i;
      }
    }

    // Now the index variable reflects the index of the closest route point
    // Must find the closest point on the route to calculate if the driver is lost,
    // If so, route must be recalculated

    // It is still not determined which segment of the route the driver is closest to,
    // so calculate the perpendicular distance from the user to the two route segments
    // either side of _routePoints[index]

    double distance1 = double.infinity;
    double distance2 = double.infinity;

    if (index > 0) {
      distance1 = _routeService.distanceFromSegment(
        location, _routePoints[index-1], _routePoints[index]);
    }
    if (index < _routePoints.length-1) {
      distance2 = _routeService.distanceFromSegment(
        location, _routePoints[index], _routePoints[index+1]);
    }

    double bearing, distance;

    // Take minimum distance between the two as distance from the line,
    // then calculate new bearing for map camera
    if (distance1 < distance2) {
      distance = distance1;
      bearing = 180 - Geolocator.bearingBetween(
        _routePoints[_closestIndex].latitude,
        _routePoints[_closestIndex].longitude,
        _routePoints[_closestIndex-1].latitude,
        _routePoints[_closestIndex-1].longitude
      );
    } else {
      distance = distance2;
      bearing = 180 - Geolocator.bearingBetween(
        _routePoints[_closestIndex+1].latitude,
        _routePoints[_closestIndex+1].longitude,
        _routePoints[_closestIndex].latitude,
        _routePoints[_closestIndex].longitude
      );
    }

    // _rerouteThreshold signifies how far the driver has to have gone off the route before
    // the route is recalculated
    double rerouteThreshold = _journeyActive ? 30 : 150;

    // Check if user is far enough off route to trigger calculating a new route
    if (distance > rerouteThreshold) {
      // Recalculate route as driver has gone off route
      await _fetchOptimizedRoute();

      // As the route has just been fetched, the closest index can be safely
      // assumed to be 0
      index = 0;

      // Calculate new bearing between route points user is between
      bearing = 180 - Geolocator.bearingBetween(
        _routePoints[1].latitude,
        _routePoints[1].longitude,
        _routePoints[0].latitude,
        _routePoints[0].longitude
      );
    }

    // Update state to reflect new changes
    setState(() {
      _closestIndex = index;
      _autoBearing = bearing;
    });
  }


  @override
  void dispose() {
    _locationStatusStream.cancel();
    super.dispose();
  }
}

class Config {
  bool inTestMode;
  Config({this.inTestMode = false});
}
