import 'package:ewc/service_locator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:open_route_service/open_route_service.dart';
import 'package:latlong2/latlong.dart';
import 'package:ewc/services/stops_service.dart';
import 'package:ewc/models/stop_model.dart';

// A class to store the result of a route planning request.
class RouteResult {
  // A list of LatLng objects representing the route
  final List<LatLng> routeCoordinates;
  // A map of instructions with the key as a list of coordinates(that are the range between which the instruction should be displayed) 
  // and the value as the instruction message.
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

  // Plans and returns the optimized route between a list of stops and the navigation instructions for that route.
  Future<RouteResult> routePlanning(LatLng userLocation, List<Stop> stops) async {
    final depot = LatLng(51.4533, -2.6257);
    
    List<VroomJob> jobs = [];
    // Iterate through each stop and create a VroomJob object for it.
    // This is used to define the locations that need to be visited.
    for (int idx = 0; idx < stops.length; idx++) {
      LatLng stop = stops[idx].location;
      jobs.add(VroomJob(
        id: idx + 1,
        location: ORSCoordinate(latitude: stop.latitude, longitude: stop.longitude),
      ));
    }


    List<VroomVehicle> vehicles = [];
    // Create a VroomVehicle object for each vehicle.
    // This is used to define the starting and ending locations for each vehicle.
    VroomVehicle vehicle = VroomVehicle(
      id: 1,
      start: ORSCoordinate(latitude: userLocation.latitude, longitude: userLocation.longitude),
      end: ORSCoordinate(latitude: depot.latitude, longitude: depot.longitude),
      profile: 'driving-hgv',
    );

    vehicles.add(vehicle);
    // Send the optimization request to the API which returns the optimized route order.
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
    // Get the detailed route data for the optimized order
    final directionsDataResponse = await client.directionsMultiRouteDataPost(
      coordinates: optimizedOrder,
      profileOverride: ORSProfile.drivingHgv, // Set profile to heavy goods vehicle
      instructions: true,
    );
    // Initialize an empty map to store instructions with waypoints as keys and instruction messages as values.
    final Map<List<double>, String> instructionsMap = {};

    //Extract the instructions from the response
    final route = directionsDataResponse.first;
    for (var segment in route.segments) {
      for (var step in (segment.steps)) {
        // Map the waypoints to the corresponding instruction message.
        instructionsMap[step.wayPoints] = step.instruction;
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
            (latlng) => ORSCoordinate(
            latitude: latlng.latitude, longitude: latlng.longitude))
        .toList();

    try {
      // Request time duration matrix from ORS API
      TimeDistanceMatrix matrix = await client.matrixPost(
        locations: convertedList,
        destinations: List.generate(
            stopLocations.length - 1, (index) => index + 1),
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

  // This function takes user location, a start point and an endpoint
  // It then calculates the perpendicular distance of the user from the line between
  // startPoint and endPoint and returns it as a double
  double distanceFromSegment(LatLng location, LatLng startPoint, LatLng endPoint) {
    // Vector from startPoint to user location
    LatLng v = LatLng(
        location.latitude-startPoint.latitude,
        location.longitude-endPoint.longitude
    );

    // Vector representing line segment
    LatLng w = LatLng(
        endPoint.latitude-startPoint.latitude,
        endPoint.longitude-startPoint.longitude
    );

    // Project v onto w using dot product
    double dotProduct = w.latitude * v.latitude + w.longitude * v.longitude;

    // Calculate squared length of line segment
    double routeSegmentLengthSquared =
        w.latitude * w.latitude +
        w.longitude * w.longitude;

    double projection = dotProduct / routeSegmentLengthSquared;

    // Clamp projection to ensure it lies on the routeSegment
    double clampedProjection = projection.clamp(0, 1);

    // Calculate LatLng of projected point
    LatLng projectedPoint = LatLng(
        startPoint.latitude + clampedProjection * w.latitude,
        startPoint.longitude + clampedProjection * w.longitude
    );

    // Return distance between user location and projected point
    double distance = Geolocator.distanceBetween(
        location.latitude,
        location.longitude,
        projectedPoint.latitude,
        projectedPoint.longitude
    );

    return distance;
  }
}