import 'package:bird_x/services/location_services.dart';
import 'package:bird_x/services/registration_services.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';

class LoginController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController location = TextEditingController();

  String countryCode = "";
  String latitude = "";
  String longitude = "";
   String groupValue = "Male";
  changeGender(String value) {
    groupValue = value;
    update();
  }

  bool isObsecure = true;
  changeObsecurity() {
    isObsecure = !isObsecure;
    update();
  }

  bool isLoading = false;
  login(context) async {
    isLoading = true;
    update();
    if (email.text.isEmpty || !email.text.isEmail) {
      AppSnackbar.showSnackbar(
          title: "Error", message: "Please enter valid email!");
    } else if (password.text.isEmpty || password.text.length < 6) {
      AppSnackbar.showSnackbar(
          title: "Error", message: "Please enter valid password!");
    } else {
      await RegistrationServices()
          .login(context, email: email.text, password: password.text);
    }
    isLoading = false;
    update();
  }

  pickLocation(context) async {
    location.text = "loading....";
    await await AppNavigation.to(
      context,
      nextPage: PlacePicker(
        apiKey: "AIzaSyDq33g2UnBUqsMbCPvHT8imFd20IsLuel0",
        initialPosition: const LatLng(30.1811532, 71.3098456),
        enableMyLocationButton: true,
        useCurrentLocation: true,
        onPlacePicked: (value) async {
          latitude = value.geometry!.location.lat.toString();
          longitude = value.geometry!.location.lng.toString();
          AppNavigation.back(context);
          location.text = await LocationServices.translateAddress(
              latitude: value.geometry!.location.lat,
              longitude: value.geometry!.location.lng);
        },
      ),
    );
  }

  bool googleLoading = false;
  googleLogin(context) async {
    googleLoading = true;
    update();
    await RegistrationServices().googleLogin(context);
    googleLoading = false;
    update();
  }
}
