import 'dart:async';

import 'package:bird_x/services/registration_services.dart';
import 'package:bird_x/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OtpController extends GetxController {
  TextEditingController otp = TextEditingController();
  String email = "";
  bool isOtpExpires = false;
  DateTime currentTime = DateTime(
    2023,
    0,
    0,
    0,
    1,
    0,
  );
  Timer? timer;
  String? otpTime;
  startTimer() {
    isOtpExpires = false;
    currentTime = DateTime(
      2023,
      0,
      0,
      0,
      1,
      0,
    );
    otpTime = DateFormat().add_ms().format(currentTime);
    update();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      DateTime newTime = currentTime.subtract(
        Duration(seconds: timer.tick),
      );

      otpTime = DateFormat().add_ms().format(newTime);

      update();
      if (newTime.second <= 0) {
        timer.cancel();
        isOtpExpires = true;
        update();
      }
    });
  }

  disposeTimer() {
    timer?.cancel();
  }

  bool isLoading = false;
  verifyOtp(context, {required bool isForgetEmail}) async {
    if (otp.text.isEmpty || otp.text.length < 5) {
      AppSnackbar.showSnackbar(title: "Error", message: "Please enter valid otp!");
    } else {
      isLoading = true;
      update();
      await RegistrationServices().verifyOtp(
        context,
        email: email,
        isForgetEmail: isForgetEmail,
        otp: otp.text,
      );
      isLoading = false;
      update();
    }
  }
}
