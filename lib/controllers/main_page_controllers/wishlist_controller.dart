import 'package:bird_x/models/all_product_model.dart';
import 'package:bird_x/services/local_db_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishlistController extends GetxController {
  final LocalDbService _localDbService = LocalDbService();
  TextEditingController query = TextEditingController();
  List<ProductData> productList = [];
  queryProduct({required List<ProductData> products}) {
    productList = products.where((e) => e.name.toString().toLowerCase().contains(query.text.toLowerCase())).toList();
    update();
  }

  List<bool> checkedList = [];
  changeCheck(index, bool value, ProductData productData) {
    var jsonData = productData.toJson();
    checkedList[index] = value;
    update();
    if (value) {
      _localDbService.addItem(jsonData);
      productList.add(productData);
    } else {
      _localDbService.removeItem(jsonData);
      productList.remove(productData);
    }
  }
}
