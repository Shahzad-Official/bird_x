import 'package:geolocator/geolocator.dart';

class LocationServices {
  Future<Position> determinePosition() async {
    Position currentPosition;
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      var res = await Geolocator.openLocationSettings();
      if (res) {
        currentPosition = await Geolocator.getCurrentPosition();
        return currentPosition;
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();

        currentPosition = await Geolocator.getCurrentPosition();
        return currentPosition;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      var res = await Geolocator.openAppSettings();

      if (res) {
        await Geolocator.requestPermission();

        currentPosition = await Geolocator.getCurrentPosition();
        return currentPosition;
      }
    }

    currentPosition = await Geolocator.getCurrentPosition();

    return currentPosition;
  }
}
