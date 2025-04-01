import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'package:ewc/services/location_service.dart';

/// This file manages the state of the stops and provides
/// functionality to interact with the list of stops.
///
/// Functions:
/// - `initialiseLocationServices()`: Initializes the location services.
/// - `setTracking(bool setting)`: Enables or disables tracking.
/// - `resetDistance()`: Resets the distance travelled.
/// - `initialisePositionStream()`: Initializes the location stream.
/// - `dispose()`: Disposes the location stream.

class LocationProvider extends ChangeNotifier {
  LatLng? _latestLocation;
  StreamSubscription<Position>? _locationStream;

  // Variable to keep track of how far user has travelled
  double _distanceTravelled = 0;
  bool _trackingEnabled = false; // Whether user's distance is being tracked

  LatLng? get latestLocation => _latestLocation;
  double get distanceTravelled => _distanceTravelled;

  // Function to set whether tracking is enabled or disabled
  void setTracking(bool setting) {
    _trackingEnabled = setting;
  }

  // Function to reset distance after end of route
  void resetDistance() {
    _distanceTravelled = 0;
  }

  void setLatestLocationForTest(LatLng? newLoc) {
    _latestLocation = newLoc;
  }

  Future<void> initialiseLocationServices() async {

    // Ask user for location permissions
    _latestLocation = null;
    bool locationAccessible = await getLocationPermissions();
    if (locationAccessible) {
      initialisePositionStream();
    } else {
      locationAccessible = await requestLocationPermissions();
      if (locationAccessible) {
        initialisePositionStream();
      }
    }
  }

  // Function to initialise location stream.
  // The stream updates the latestLocation variable to new location if the
  // device moves more than 3 metres from the previous latestLocation value.
  void initialisePositionStream() {
    final LocationSettings locationSettings = LocationSettings(
      distanceFilter: 3, // Minimum distance device must move (in metres) to update the location
    );
    // Create a location stream which returns device location at regular intervals
    _locationStream = Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) {

      // Only track distance if tracking is enabled
      if (_trackingEnabled && _latestLocation != null) {
        double distance = Geolocator.distanceBetween(
            position!.latitude, position.longitude, _latestLocation!.latitude, _latestLocation!.longitude);
        _distanceTravelled += distance; // Add distance to currently accumulated distance
      }
      _latestLocation = LatLng(position!.latitude, position.longitude);
      notifyListeners();
    });

  }

  @override
  void dispose() {
    _locationStream?.cancel();
    super.dispose();
  }
}