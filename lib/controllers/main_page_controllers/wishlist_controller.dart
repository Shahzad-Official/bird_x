import 'package:bird_x/models/all_product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WishlistController extends GetxController {
  TextEditingController query = TextEditingController();
  List<ProductData> productList = [];
  queryProduct({required List<ProductData> products}) {
    productList = products.where((e) => e.name.toString().toLowerCase().contains(query.text.toLowerCase())).toList();
    update();
  }
}
