import 'package:geolocator/geolocator.dart';


/// This file manages the location services and provides functions to interact with the device's location.
///
/// Functions:
/// - `getLocationPermissions()`: Checks if the app has location permissions.
/// - `requestLocationPermissions()`: Requests permission to access the device's location.

Future<bool> getLocationPermissions() async {
  // Test if location services are enabled
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled on the device
    return false;
  }

  // Test if the app has location permissions
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
    return false;
  }

  // If code reaches here then location is enabled
  // and permission has been granted, so return true.
  return true;
}

// Function to request permission to access device location
Future<bool> requestLocationPermissions() async {

  // Test if location services are enabled
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled on the device
    return false;
  }

  LocationPermission permission = await Geolocator.requestPermission();
  if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
    return false;
  }

  // Return true because the permission has now been granted.
  return true;
}