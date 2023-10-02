import 'package:bird_x/main.dart';
import 'package:bird_x/models/all_product_model.dart';

class LocalDbService {
  addItem(data) {
    if (box.get("wishlist") != null) {
      List list = box.get("wishlist");
      if (list.any(
        (element) => element["_id"] == data["_id"],
      )) {
      } else {
        list.add(data);
        box.put("wishlist", list);
      }
    } else {
      List list = [];
      list.add(data);
      box.put("wishlist", list);
    }
  }

  removeItem(data) {
    if (box.get("wishlist") != null) {
      List list = box.get("wishlist");
      if (list.any(
        (element) => element["_id"] == data["_id"],
      )) {
        list.removeWhere(
          (element) => element['_id'] == data["_id"],
        );
        box.put("wishlist", list);
      } else {}
    }
  }

  bool isChecked(ProductData productData) {
    bool isCheck = false;
    if (box.get("wishlist") != null) {
      List list = box.get("wishlist");
      isCheck = list.any(
        (element) => element["_id"].toString() == productData.sId.toString(),
      );
    }
    return isCheck;
  }
}
