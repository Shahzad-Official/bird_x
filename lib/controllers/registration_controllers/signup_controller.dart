import 'dart:convert';
import 'dart:io';

import 'package:bird_x/services/registration_services.dart';
import 'package:bird_x/utils/app_image_utils.dart';
import 'package:bird_x/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SignupController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController location = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cpassword = TextEditingController();
  String countryCode = "";

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

  File? profile;
  String base64Image = "";
  pickProfile({required ImageSource source}) async {
    // ignore: invalid_use_of_visible_for_testing_member
    await ImagePicker.platform
        .getImageFromSource(source: source)
        .then((value) async {
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
      AppSnackbar.showSnackbar(
          title: "Error", message: "Please select your profile picture!");
    } else if (email.text.isEmpty || !email.text.isEmail) {
      AppSnackbar.showSnackbar(
          title: "Error", message: "Please enter valid email address!");
    } else if (number.text.isEmpty) {
      AppSnackbar.showSnackbar(
          title: "Error", message: "Please enter your phone number!");
    }
    //  else if (location.text.isEmpty) {
    //   AppSnackbar.showSnackbar(title: "Error", message: "Please select your location!");
    // }
    else if (password.text.isEmpty || password.text.length < 6) {
      AppSnackbar.showSnackbar(
          title: "Error",
          message: "Please enter password having at least 6 characters!");
    } else if (password.text != cpassword.text) {
      AppSnackbar.showSnackbar(
          title: "Error", message: "Please check your confirm password!");
    } else {
      await _registrationServices.registerUser(
        context,
        firstName: firstName.text,
        lastName: lastName.text,
        password: password.text,
        email: email.text,
        mobile: countryCode + number.text,
        profile: base64Image,
        address: "address",
        latitude: "latitude",
        longitude: "longitude",
        gender: groupValue,
      );
    }
    isLoading = false;
    update();
  }
}
