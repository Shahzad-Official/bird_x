import 'package:get/get.dart';

class AppSnackbar {
  static showSnackbar({
    required String title,
    required String message,
  }) {
    Get.snackbar(
      title,
      message,
    );
  }
}
