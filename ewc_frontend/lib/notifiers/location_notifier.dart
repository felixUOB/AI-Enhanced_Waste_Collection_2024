import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import 'package:ewc/services/location_service.dart';


// This class provides location updates to any consumers which may require them
class LocationProvider extends ChangeNotifier {
  LatLng? _latestLocation;
  StreamSubscription<Position>? _locationStream;

  double _distanceTravelled = 0;
  bool _trackingEnabled = false;

  LatLng? get latestLocation => _latestLocation;
  double get distanceTravelled => _distanceTravelled;

  void setTracking(bool setting) {
    _trackingEnabled = setting;
  }

  void resetDistance() {
    _distanceTravelled = 0;
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
  // device moves more than 5 metres from the previous latestLocation value.
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