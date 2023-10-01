import 'package:bird_x/main.dart';
import 'package:bird_x/models/all_product_model.dart';
import 'package:bird_x/services/product_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePageController extends GetxController {
  TextEditingController query = TextEditingController();
  final ProductServices _productServices = ProductServices();
  List<ProductData> productList = [];
  List<ProductData> searchedProductList = [];
  bool get isSearching => query.text.trim().isNotEmpty ? true : false;
  queryProducts() {
    searchedProductList = productList.where((e) => e.name.toString().toLowerCase().contains(query.text.toLowerCase())).toList();
    update();
  }

  int currentPage = 1;
  bool isLoading = true;
  paginateProducts() async {
    if (currentPage < int.parse(box.get("totalPages"))) {
      currentPage++;

      query.text = "";
      await _productServices.getAllProducts(page: currentPage);
      for (var i in _productServices.allProductsModel.productData!) {
        productList.add(i);
      }
      isLoading = false;
      update();
    } else {
      isLoading = false;
      update();
    }
  }
}
