import 'dart:convert';
import 'dart:io';

import 'package:bird_x/constants/api_constant.dart';
import 'package:bird_x/main.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/views/main_page_views/menu_views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/app_snackbar.dart';

class AddProductServices {
  String get token => box.get("token");

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

      print('Response Status Code: ${response.statusCode}');

      var responseData = await response.stream.bytesToString();
      print('Response Data: $responseData');

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
