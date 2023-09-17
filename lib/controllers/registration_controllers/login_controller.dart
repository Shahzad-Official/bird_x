import 'package:get/get.dart';

class LoginController extends GetxController {
  bool isObsecure = true;
  changeObsecurity() {
    isObsecure = !isObsecure;
    update();
  }
}
