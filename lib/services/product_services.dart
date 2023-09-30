import 'dart:convert';

import 'package:bird_x/constants/api_constant.dart';
import 'package:bird_x/main.dart';
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

    await http
        .get(
      Uri.parse(ApiConstant.baseUrl + ApiConstant.categories),
      headers: headers,
    )
        .then((value) {
      var data = jsonDecode(value.body);
      if (value.statusCode == 200) {
        categoryModel = CategoryModel.fromJson(data);
      } else {
        AppSnackbar.showSnackbar(title: "Error", message: data['message']);
      }
    }).catchError((err) {
      debugPrint("Error to load data=> $err");
    });
    return categoryModel;
  }

  Future<void> addProduct(
    context, {
    required String price,
    required String thumbnail,
    required String categoryName,
    required String name,
    required String description,
    required String latitude,
    required String longitude,
    required List<String> multiImages,
    required String categoryId,
    required String address,
    // required String location,
  }) async {
    print("categoryId: $categoryId");
    var body = jsonEncode({
      "categoryId": categoryId,
      "categoryName": categoryName,
      "description": description,
      "name": name,
      "price": price,
      "address": address,
      "latitude": latitude,
      "longitude": longitude,
      "otherPics": multiImages,
      "thumbnail": thumbnail,
    });

    await post(
      Uri.parse(ApiConstant.baseUrl + ApiConstant.addProduct),
      headers: {
        "Authorization": "Bearer $token",
      },
      body: body,
    ).then((value) {
      print("Response status code: ${value.statusCode}");
      print("Response body: ${value.body}");
      if (value.statusCode == 201) {
        AppNavigation.offAll(
          context,
          nextPage: const MainPage(),
        );
        print(value.statusCode);
      } else if (value.statusCode == 400) {
        var data = jsonDecode(value.body);
        AppSnackbar.showSnackbar(title: "Error", message: data['message']);
        print(value.statusCode);
      } else {
        print(value.statusCode);
      }
    }).catchError((err) {
      debugPrint("Error to load data => $err");
    });
  }
}
