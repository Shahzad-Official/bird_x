import 'dart:convert';
import 'dart:io';

import 'package:bird_x/constants/api_constant.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/utils/app_snackbar.dart';
import 'package:bird_x/views/main_page_views/main_page.dart';
import 'package:bird_x/views/registration_views/otp_verification.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class RegistrationServices {
  registerUser(
    context, {
    required String firstName,
    required String lastName,
    required String password,
    required String email,
    required String mobile,
    required String profile,
    required String address,
    required String latitude,
    required String longitude,
    required String gender,
  }) async {
    var body = jsonEncode({
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "password": password,
      "mobile": mobile,
      "profile": profile,
      "fileType": "png",
      "location": {
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
      },
      "gender": gender,
    });
    await post(
      Uri.parse(ApiConstant.baseUrl + ApiConstant.signUp),
      headers: {"Content-Type": "application/json"},
      body: body,
    ).then((value) {
      var data = jsonDecode(value.body);

      AppSnackbar.showSnackbar(title: "Success", message: data['message']);
      if (value.statusCode == 201) {
        AppSnackbar.showSnackbar(title: "Success", message: data['message']);
        AppNavigation.offAll(
          context,
          nextPage: OtpVerification(
            email: email,
          ),
        );
      } else {
        AppSnackbar.showSnackbar(title: "Error", message: data['message']);
      }
    }).catchError((err) {
      debugPrint(err.toString());
      if (err is SocketException) {
        AppSnackbar.showSnackbar(title: "Error", message: "Check your internet connection");
      } else {
        AppSnackbar.showSnackbar(title: "Error", message: err.toString());
      }
    });
  }

  login(
    context, {
    required String email,
    required String password,
  }) async {
    var body = jsonEncode({
      "email": email,
      "password": password,
    });
    await post(
      Uri.parse(ApiConstant.baseUrl + ApiConstant.login),
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    ).then((value) {
      var data = jsonDecode(value.body);

      if (value.statusCode == 200) {
        AppSnackbar.showSnackbar(title: "Success", message: data['message']);
        AppNavigation.offAll(
          context,
          nextPage: const MainPage(),
        );
      } else {
        AppSnackbar.showSnackbar(title: "Error", message: data['message']);
      }
    }).catchError((err) {
      debugPrint(err.toString());
      if (err is SocketException) {
        AppSnackbar.showSnackbar(title: "Error", message: "Check your internet connection");
      } else {
        AppSnackbar.showSnackbar(title: "Error", message: err.toString());
      }
    });
  }
}
