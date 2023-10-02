import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationServices {
  Future<bool> requestPermission() async {
    var result = await Geolocator.openLocationSettings();

    await Geolocator.requestPermission();

    return result;
  }

  Future<bool> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      var result = await requestPermission();
      if (result) {
        await Geolocator.requestPermission();
        permission = await Geolocator.checkPermission();

        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        if (permission == LocationPermission.deniedForever) {
          var res = await Geolocator.openAppSettings();

          if (res) {
            await Geolocator.openLocationSettings();
            await Geolocator.requestPermission();
          }
        }
      }
    }
    return serviceEnabled;
  }

  static Future<String> translateAddress({required double latitude, required double longitude}) async {
    String address = '';
    await placemarkFromCoordinates(latitude, longitude).then((value) {
      address = "${value.first.subAdministrativeArea}, ${value.first.administrativeArea}, ${value.first.country}";
    });
    return address;
  }
}
