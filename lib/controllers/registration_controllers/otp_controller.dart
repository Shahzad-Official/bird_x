import 'dart:async';

import 'package:get/get.dart';
import 'package:intl/intl.dart';

class OtpController extends GetxController {
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
}
