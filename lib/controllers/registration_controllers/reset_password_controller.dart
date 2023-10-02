import 'package:bird_x/services/registration_services.dart';
import 'package:bird_x/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordController extends GetxController {
  TextEditingController password = TextEditingController();
  TextEditingController cpassword = TextEditingController();
  String email = "";
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
  resetPass(context) async {
    isLoading = true;
    update();
    if (password.text.isEmpty || password.text.length < 6) {
      AppSnackbar.showSnackbar(title: "Error", message: "Please enter password having at least 6 characters!");
    } else if (password.text != cpassword.text) {
      AppSnackbar.showSnackbar(title: "Error", message: "Please check your confirm password!");
    } else {
      await RegistrationServices().forgetPassword(
        context,
        email: email,
        password: password.text,
      );
    }
    isLoading = false;
    update();
  }
}
