import 'package:geolocator/geolocator.dart';


// Function to return device's current location
Future<Position> determineLocation() async {

  // Test if location services are enabled
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled on the device
    return Future.error("Location services are disabled.");
  }

  // Test if the app has location permissions
  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    // If the app does not have location permission, request permission
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error("Location permissions are denied");
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error("Location permissions are denied.");
  }

  // If code reaches here then the location service is enabled
  // and permission has been granted. Get device location.
  return await Geolocator.getCurrentPosition();
}