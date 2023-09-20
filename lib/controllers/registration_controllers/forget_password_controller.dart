import 'package:bird_x/services/registration_services.dart';
import 'package:bird_x/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgetPasswordController extends GetxController {
  TextEditingController email = TextEditingController();
  bool isLoading = false;
  sendOtp(context) async {
    isLoading = true;
    update();
    if (!email.text.isEmail) {
      AppSnackbar.showSnackbar(title: "Error", message: "Please enter valid email!");
    } else {
      await RegistrationServices().sendOtp(
        context,
        email: email.text,
      );
    }
    isLoading = false;
    update();
  }
}
