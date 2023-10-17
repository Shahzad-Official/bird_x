import 'dart:convert';
import 'dart:io';

import 'package:bird_x/controllers/location_controller.dart';
import 'package:bird_x/services/registration_services.dart';
import 'package:bird_x/utils/app_image_utils.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/utils/app_snackbar.dart';
import 'package:bird_x/utils/location_utils.dart';
import 'package:bird_x/widgets/app_location_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

class SignupController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cpassword = TextEditingController();
  TextEditingController refCode = TextEditingController();
  final LocationController _locationController = Get.put(LocationController());
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

  bool isObsecure1 = true;
  changeObsecurity1() {
    isObsecure1 = !isObsecure1;
    update();
  }

  bool isLoading = false;
  final RegistrationServices _registrationServices = RegistrationServices();

  pickLocation(context) async {
    location.text = "loading....";
    await _locationController.pickCurrentLocation();
    if (_locationController.currentPosition == null) {
      location.text = "Tap Again";
    } else {
      LatLng latLng;
      latLng = _locationController.currentPosition == null ? const LatLng(0, 0) : LatLng(_locationController.currentPosition!.latitude!, _locationController.currentPosition!.longitude!);
      await AppNavigation.to(
        context,
        nextPage: AppLocationPicker(
          latLng: latLng,
          onPick: (latLng) async {
            location.text = await LocationUtils.translateAddress(latitude: latLng.latitude, longitude: latLng.longitude);
            latitude = latLng.latitude.toString();
            longitude = latLng.longitude.toString();
          },
        ),
      );
    }
  }

  File? profile;
  String base64Image = "";
  pickProfile({required ImageSource source}) async {
    // ignore: invalid_use_of_visible_for_testing_member
    await ImagePicker.platform.getImageFromSource(source: source).then((value) async {
      if (value != null) {
        var newprofile = File(value.path);
        var fileSize = await AppImageUtils.fileSize(newprofile);
        if (fileSize > 2) {
          var file = await AppImageUtils.compressImage(
            file: newprofile,
            quality: fileSize > 5 && fileSize <= 10
                ? 20
                : fileSize > 10
                    ? 30
                    : 50,
          );

          profile = file;
        } else {
          profile = newprofile;
        }
        base64Image = base64Encode(profile!.readAsBytesSync());

        update();
      } else {}
    }).catchError((err) {
      if (err is PathAccessException) {
      } else if (err is FileSystemException) {}
    });
  }

  registerUser(context) async {
    isLoading = true;
    update();
    if (profile == null) {
      AppSnackbar.showSnackbar(title: "Error", message: "Please select your profile picture!");
    } else if (email.text.isEmpty || !email.text.isEmail) {
      AppSnackbar.showSnackbar(title: "Error", message: "Please enter valid email address!");
    } else if (number.text.isEmpty) {
      AppSnackbar.showSnackbar(title: "Error", message: "Please enter your phone number!");
    } else if (location.text.isEmpty || location.text.toLowerCase().contains("tap again")) {
      AppSnackbar.showSnackbar(title: "Error", message: "Please select your location!");
    } else if (password.text.isEmpty || password.text.length < 6) {
      AppSnackbar.showSnackbar(title: "Error", message: "Please enter password having at least 6 characters!");
    } else if (password.text != cpassword.text) {
      AppSnackbar.showSnackbar(title: "Error", message: "Please check your confirm password!");
    } else {
      await _registrationServices.registerUser(
        context,
        mobileCode: countryCode,
        firstName: firstName.text,
        lastName: lastName.text,
        password: password.text,
        email: email.text,
        mobile: number.text,
        profile: base64Image,
        address: location.text,
        latitude: latitude,
        longitude: longitude,
        gender: groupValue,
        refCode: refCode.text,
      );
    }
    isLoading = false;
    update();
  }
}
