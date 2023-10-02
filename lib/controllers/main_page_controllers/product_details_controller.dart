import 'package:get/get.dart';

class ProductDetailsController extends GetxController {
  int currentIndex = 0;
  changeIndex(int index) {
    currentIndex = index;
    update();
  }

  bool isReadMore = true;
  changeReadMore() {
    isReadMore = !isReadMore;
    update();
  }
}
