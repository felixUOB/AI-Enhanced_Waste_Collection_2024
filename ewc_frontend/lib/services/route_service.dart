import 'package:ewc/service_locator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:open_route_service/open_route_service.dart';
import 'package:latlong2/latlong.dart';
import 'package:ewc/services/stops_service.dart';
import 'package:ewc/models/stop_model.dart';

class RouteResult {
  final List<LatLng> routeCoordinates;
  final Map<List<double>, String> instructionsMap;

  RouteResult(this.routeCoordinates, this.instructionsMap);
}

// A service class to manage route fetching from OpenRouteService API
class RouteService {
  final OpenRouteService client;
  final stopsService = getIt<StopsService>();

  RouteService._(this.client);

  // Static constructor to instantiate using API key asynchronously
  static Future<RouteService> create() async {
    // Attempt to load the .env file
    await dotenv.load(fileName: '.env');

    // Check if the API key exists in .env; show an error message if not
    final apiKey = dotenv.env['API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception("API key missing in .env file.");
    }
    return RouteService._(OpenRouteService(apiKey: apiKey));
  }

  // Helper method to validate latitude values
  bool _isValidLatitude(double latitude) {
    return latitude >= -90.0 && latitude <= 90.0;
  }

  // Helper method to validate longitude values
  bool _isValidLongitude(double longitude) {
    return longitude >= -180.0 && longitude <= 180.0;
  }




  // Form Route between coordinates returning a list of LatLng objects representing the route
  Future<List<LatLng>> getRoute(double startLat, double startLng, double endLat, double endLng) async {
    // Input Validation
    if (!_isValidLatitude(startLat) || !_isValidLatitude(endLat)) {
      throw ArgumentError('Latitude must be between -90 and 90 degrees.');
    }
    if (!_isValidLongitude(startLng) || !_isValidLongitude(endLng)) {
      throw ArgumentError('Longitude must be between -180 and 180 degrees.');
    }

    try {
      // Fetch the route coordinates from OpenRouteService API using start and end coordinates
      final List<ORSCoordinate> routeCoordinates = await client.directionsRouteCoordsGet(
        startCoordinate: ORSCoordinate(latitude: startLat, longitude: startLng), 
        endCoordinate: ORSCoordinate(latitude: endLat, longitude: endLng),
        // Setting profile for heavy goods vehicles (HGV), suitable for routing large trucks,
        profileOverride: ORSProfile.drivingHgv,
      );

      if (routeCoordinates.isEmpty) {
        throw Exception('No route could be found between the provided coordinates.');
      }
      // Convert the list of ORSCoordinate objects into LatLng objects representing the route to be display on a map
      return routeCoordinates.map((coordinate) => LatLng(coordinate.latitude, coordinate.longitude)).toList();
    } catch (e) {
      // Debugging error log
      print('Error fetching route: $e');
      // Rethrow the exception to allow higher-level handlers to manage it
      rethrow;
    }
  }


  Future<RouteResult> routePlanning(List<Stop> stops) async {
    final depot = LatLng(51.4533, -2.6257);
    
    List<VroomJob> jobs = [];

    for (int idx = 0; idx < stops.length; idx++) {
      LatLng stop = stops[idx].location;
      jobs.add(VroomJob(
        id: idx + 1,
        location: ORSCoordinate(latitude: stop.latitude, longitude: stop.longitude),
      ));
    }


    List<VroomVehicle> vehicles = [];

    VroomVehicle vehicle = VroomVehicle(
      id: 1,
      start: ORSCoordinate(latitude: depot.latitude, longitude: depot.longitude),
      end: ORSCoordinate(latitude: depot.latitude, longitude: depot.longitude),
      profile: 'driving-hgv',
    );

    vehicles.add(vehicle);

    final response = await client.optimizationDataPost(jobs: jobs, vehicles: vehicles);
  
    if (response.routes.isEmpty) {
      throw Exception('No optimized route could be found.');
    }
    
     // Extract the optimized order of stops
    final optimizedOrder = <ORSCoordinate>[];
    if (response.routes.first.steps != null) {
      for (var step in response.routes.first.steps!) {
        final location = step.location;
        optimizedOrder.add(ORSCoordinate(latitude: location.latitude, longitude: location.longitude)); // Assuming location has latitude and longitude properties
      }
    }

      // Get the detailed route coordinates for the optimized order
    final directionsResponse = await client.directionsMultiRouteCoordsPost(
      coordinates: optimizedOrder,
      profileOverride: ORSProfile.drivingHgv, // Set profile to heavy goods vehicle
      instructions: true,
    );

    if (directionsResponse.isEmpty) {
      throw Exception('No route could be found.');
    }
    final directionsDataResponse = await client.directionsMultiRouteDataPost(
      coordinates: optimizedOrder,
      profileOverride: ORSProfile.drivingHgv, // Set profile to heavy goods vehicle
      instructions: true,
    );

    final Map<List<double>, String> instructionsMap = {};

    for (var route in directionsDataResponse) {
      final segments = route.segments;
      for (var segment in segments) {
        for (var step in (segment.steps)) {
          instructionsMap[step.wayPoints] = step.instruction;
          print('Instruction: ${step.instruction} ${step.wayPoints} ${step.name}' );
        }
      }
    }

    // Convert the list of ORSCoordinate objects into LatLng objects representing the route to be display on a map
    List<LatLng> routeCoordinates = directionsResponse.map((coordinate) => LatLng(coordinate.latitude, coordinate.longitude)).toList();

    return RouteResult(routeCoordinates, instructionsMap);

  }


  // This function takes two values, source and destinations and returns
  // a matrix of the time it takes to get from that source to each destination
  Future<List<int>> getStopTimes(LatLng source, List<LatLng> stopLocations) async {

    // Convert stopLocations list from LatLng to ORSCoordinates
    stopLocations.insert(0, source); // Add source as initial item in array
    List<ORSCoordinate> convertedList = stopLocations.map(
            (latlng) => ORSCoordinate(latitude: latlng.latitude, longitude: latlng.longitude)).toList();

    try {
      // Request time duration matrix from ORS API
      TimeDistanceMatrix matrix = await client.matrixPost(
        locations: convertedList,
        destinations: List.generate(stopLocations.length - 1, (index) => index + 1),
        sources: List.generate(stopLocations.length - 1, (index) => index),
        profileOverride: ORSProfile.drivingHgv,
      );

      List<int> finalDurations = [];
      double previousStopValue = 0;

      for (int i = 0; i < matrix.durations.length; i++) {
        // Values we want are on the diagonal of the array
        double stopValue = matrix.durations[i][i] + previousStopValue;
        // Convert to minutes and floor the value
        finalDurations.add((stopValue / 60).floor());
        previousStopValue = stopValue; // Keep track of concurrent stop time
      }

      // Return as array with each element as time to that stop
      return finalDurations;

    } catch (e) {
      print('Error calculating stop timings: $e');
      // Rethrow the exception to allow higher-level handlers to manage it
      rethrow;
    }
  }
}