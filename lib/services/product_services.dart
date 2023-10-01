import 'dart:convert';

import 'package:bird_x/constants/api_constant.dart';
import 'package:bird_x/main.dart';
import 'package:bird_x/models/all_product_model.dart';
import 'package:bird_x/models/category_model.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/views/main_page_views/main_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../utils/app_snackbar.dart';

class ProductServices {
  String get token => box.get("token");
  Future<CategoryModel> fetchCategories() async {
    CategoryModel categoryModel = CategoryModel();

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
    if (box.get("allCategories") != null) {
      var data = jsonDecode(box.get("allCategories"));
      categoryModel = CategoryModel.fromJson(data);
      http
          .get(
        Uri.parse(ApiConstant.baseUrl + ApiConstant.categories),
        headers: headers,
      )
          .then((value) {
        var data = jsonDecode(value.body);
        if (value.statusCode == 200) {
          box.put("allCategories", value.body);
        } else {
          AppSnackbar.showSnackbar(title: "Error", message: data['message']);
        }
      }).catchError((err) {
        debugPrint("Error to load data=> $err");
      });
      return categoryModel;
    } else {
      await http
          .get(
        Uri.parse(ApiConstant.baseUrl + ApiConstant.categories),
        headers: headers,
      )
          .then((value) {
        var data = jsonDecode(value.body);
        if (value.statusCode == 200) {
          box.put("allCategories", value.body);
          categoryModel = CategoryModel.fromJson(data);
        } else {
          AppSnackbar.showSnackbar(title: "Error", message: data['message']);
        }
      }).catchError((err) {
        debugPrint("Error to load data=> $err");
      });
      return categoryModel;
    }
  }

  Future<void> addProduct(
    context, {
    required String price,
    required String thumbnail,
    required String name,
    required String description,
    required String latitude,
    required String longitude,
    required List<String> multiImages,
    required String categoryId,
    required String address,
  }) async {
    var body = jsonEncode({
      "categoryId": categoryId,
      "description": description,
      "name": name,
      "country": "Pakistan",
      "price": price,
      "address": address,
      "latitude": latitude,
      "longitude": longitude,
      "otherPics": multiImages,
      "thumbnail": thumbnail,
    });
    debugPrint(body);
    await post(
      Uri.parse(ApiConstant.baseUrl + ApiConstant.product),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    ).then((value) {
      var data = jsonDecode(value.body);
      if (value.statusCode == 201) {
        AppNavigation.offAll(
          context,
          nextPage: const MainPage(),
        );
      } else {
        AppSnackbar.showSnackbar(title: "Error", message: data['message']);
      }
    }).catchError((err) {
      debugPrint("Error to load data => $err");
    });
  }

  AllProductsModel allProductsModel = AllProductsModel();
  getAllProducts() async {
    
    await get(
      Uri.parse(ApiConstant.baseUrl + ApiConstant.product),
      headers: {
        "Content-Type": "application/json",
      },
    ).then((value) {
      var data = jsonDecode(value.body);
      if (value.statusCode == 200) {
        allProductsModel = AllProductsModel.fromJson(data);
      }
    }).catchError((err) {
      debugPrint("products fetching eror=> $err");
    });
  }
}
