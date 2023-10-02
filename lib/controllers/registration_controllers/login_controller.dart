import 'package:bird_x/services/registration_services.dart';
import 'package:bird_x/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController number = TextEditingController();

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
      AppSnackbar.showSnackbar(title: "Error", message: "Please enter valid email!");
    } else if (password.text.isEmpty || password.text.length < 6) {
      AppSnackbar.showSnackbar(title: "Error", message: "Please enter valid password!");
    } else {
      await RegistrationServices().login(context, email: email.text, password: password.text);
    }
    isLoading = false;
    update();
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
