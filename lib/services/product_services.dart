import 'dart:convert';
import 'dart:io';

import 'package:bird_x/constants/api_constant.dart';
import 'package:bird_x/main.dart';
import 'package:bird_x/models/category_model.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/views/main_page_views/menu_views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    required String profile,
    required String name,
    required String description,
    required String latitude,
    required String longitude,
    required List<File?> multiImages,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConstant.baseUrl + ApiConstant.addProduct),
      );

      request.fields['price'] = price;
      request.fields['name'] = name;
      request.fields['thumbnail'] = profile;

      request.fields['description'] = description;
      request.fields['latitude'] = latitude;
      request.fields['longitude'] = longitude;
      request.fields['categoryId'] = 'your_category_id_here';

      // Add image files to the request as MultipartFile
      for (var file in multiImages) {
        if (file != null) {
          request.files.add(
            await http.MultipartFile.fromPath('otherPics', file.path),
          );
        }
      }
      request.headers['Authorization'] = 'Bearer $token';

      var response = await request.send();

      var responseData = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = await response.stream.bytesToString();
        var data = jsonDecode(responseData);

        if (response.statusCode == 201) {
          box.put("token", data['token']);

          AppNavigation.offAll(
            context,
            nextPage: const HomeView(),
          );
        } else {
          AppSnackbar.showSnackbar(title: "Error", message: data['message']);
        }
      } else {
        AppSnackbar.showSnackbar(
          title: "Error",
          message: "Failed to add the product. Please try again.",
        );
      }
    } catch (error) {
      debugPrint(error.toString());
      AppSnackbar.showSnackbar(
        title: "Error",
        message: "An error occurred. Please try again later.",
      );
    }
  }
}
