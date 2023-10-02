import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppNavigation {
  static to(context, {required Widget nextPage}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => nextPage,
      ),
    );
  }

  static off(context, {required Widget nextPage}) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => nextPage,
      ),
      (route) => true,
    );
  }

  static offAll(context, {required Widget nextPage, bool deleteAll = true}) {
    if (deleteAll) {
      Get.deleteAll();
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => nextPage,
      ),
      (route) => false,
    );
  }

  static back(context) {
    Navigator.pop(context);
  }
}
