import 'package:bird_x/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppSnackbar {
  static showSnackbar({
    required String title,
    required String message,
  }) {
    bool isSuccess = title.toLowerCase().contains("message") || title.toLowerCase().contains("success");
    Get.snackbar(
      title,
      message,
      titleText: AppText(
        text: title,
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: isSuccess ? Colors.green : Colors.red,
      ),
      messageText: AppText(
        text: message,
      ),
      backgroundColor: Colors.white.withOpacity(0.6),
      borderColor: isSuccess ? Colors.green : Colors.red,
      borderWidth: 2,
    );
  }
}
