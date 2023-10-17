import 'package:geocoding/geocoding.dart';

class LocationUtils {
  static Future<String> translateAddress({required double latitude, required double longitude}) async {
    String address = '';
    await placemarkFromCoordinates(latitude, longitude).then((value) {
      address = "${value.first.subAdministrativeArea}, ${value.first.administrativeArea}, ${value.first.country}";
    });
    return address;
  }

  static Future<String> translateFullAddress({required double latitude, required double longitude}) async {
    String address = '';
    await placemarkFromCoordinates(latitude, longitude).then((value) {
      address = "${value.first.street}, ${value.first.subAdministrativeArea}, ${value.first.administrativeArea}, ${value.first.country}";
    });
    return address;
  }
}
