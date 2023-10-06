import 'package:bird_x/models/all_product_model.dart';
import 'package:bird_x/services/local_db_service.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  final LocalDbService _localDbService = LocalDbService();
  List<bool> checkedList = [];
  changeCheck(index, bool value) {
    checkedList[index] = value;
    update();
  }

  addDataToCheckList({
    required ProductData productData,
    required List<ProductData> products,
    required int index,
  }) {
    for (int i = 0; i < products.length; i++) {
      checkedList.add(false);
    }
    checkedList[index] = _localDbService.isChecked(productData);
  }

  onFavorite({
    required ProductData productData,
    required int index,
  }) {
    var jsonData = productData.toJson();
    if (_localDbService.isChecked(productData)) {
      _localDbService.removeItem(jsonData);
      changeCheck(index, false);
    } else {
      _localDbService.addItem(jsonData);
      changeCheck(index, true);
    }
  }
}
