import 'dart:convert';

import 'package:bird_x/constants/api_constant.dart';
import 'package:bird_x/main.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/utils/app_snackbar.dart';
import 'package:bird_x/views/main_page_views/main_page.dart';
import 'package:bird_x/views/registration_views/otp_verification.dart';
import 'package:bird_x/views/registration_views/reset_password.dart';
import 'package:bird_x/views/registration_views/successfull_registration.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

class RegistrationServices {
  String get token => box.get("token");
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
        box.put("token", data['token']);

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
      AppSnackbar.showSnackbar(title: "Error", message: err.toString());
      // AppSnackbar.showSnackbar(title: "Error", message: "Something went wrong please try again later!");
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
        box.put("token", data['token']);
        box.put("userData", value.body);
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
      AppSnackbar.showSnackbar(title: "Error", message: err.toString());
      // AppSnackbar.showSnackbar(title: "Error", message: "Something went wrong please try again later!");
    });
  }

  googleLogin(context) async {
    await GoogleSignIn().signOut();
    await GoogleSignIn().signIn().then(
      (value) async {
        var body = jsonEncode({
          "email": value?.email,
          "firstName": value?.displayName?.split(" ").first,
          "lastName": value?.displayName?.split(" ").last,
          "imageUrl": value!.photoUrl ?? "",
        });
        await post(
          Uri.parse(ApiConstant.baseUrl + ApiConstant.googleSigin),
          headers: {
            "Content-Type": "application/json",
          },
          body: body,
        ).then((value) {
          var data = jsonDecode(value.body);

          if (value.statusCode == 200) {
            box.put("token", data['token']);

            box.put("userData", value.body);
            AppSnackbar.showSnackbar(title: "Message", message: data['message']);
            AppNavigation.offAll(
              context,
              nextPage: const MainPage(),
            );
          } else {
            AppSnackbar.showSnackbar(title: "Error", message: data['message']);
          }
        }).catchError((err) {
          debugPrint(err);
          AppSnackbar.showSnackbar(title: "Error", message: err.toString());
          // AppSnackbar.showSnackbar(title: "Error", message: "Something went wrong please try again later!");
        });
      },
    ).catchError((err) {
      debugPrint(err.toString());
      AppSnackbar.showSnackbar(title: "Error", message: err.toString());
      // AppSnackbar.showSnackbar(title: "Error", message: "Something went wrong please try again later!");
    });
  }

  sendOtp(
    context, {
    required String email,
  }) async {
    var body = jsonEncode({
      "email": email,
    });
    await post(
      Uri.parse(ApiConstant.baseUrl + ApiConstant.sendOtp),
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
          nextPage: OtpVerification(
            email: email,
            isForgetEmail: true,
          ),
        );
      } else {
        AppSnackbar.showSnackbar(title: "Error", message: data['message']);
      }
    }).catchError((err) {
      debugPrint(err.toString());
      AppSnackbar.showSnackbar(title: "Error", message: err.toString());
      // AppSnackbar.showSnackbar(title: "Error", message: "Something went wrong please try again later!");
    });
  }

  verifyOtp(
    context, {
    required String email,
    required bool isForgetEmail,
    required String otp,
  }) async {
    var body = jsonEncode({
      "otp": otp,
    });
    await post(
      Uri.parse(ApiConstant.baseUrl + ApiConstant.verifyOtp),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    ).then((value) {
      var data = jsonDecode(value.body);
      if (value.statusCode == 200) {
        AppSnackbar.showSnackbar(title: "Success", message: data['message']);
        if (isForgetEmail) {
          AppNavigation.offAll(
            context,
            nextPage: ResetPassword(
              email: email,
            ),
          );
        } else {
          AppNavigation.offAll(
            context,
            nextPage: const SuccessfullRegistration(
              isForgetPass: false,
            ),
          );
        }
      } else {
        debugPrint("otp error data=> $data");
        AppSnackbar.showSnackbar(title: "Error", message: data['message']);
      }
    }).catchError((err) {
      debugPrint(err.toString());
      AppSnackbar.showSnackbar(title: "Error", message: err.toString());
      // AppSnackbar.showSnackbar(title: "Error", message: "Something went wrong please try again later!");
    });
  }

  updatePassword(
    context, {
    required String email,
    required String password,
  }) async {
    var body = jsonEncode({"email": email, "password": password});
    await post(
      Uri.parse(ApiConstant.baseUrl + ApiConstant.updatePassword),
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
          nextPage: const SuccessfullRegistration(
            isForgetPass: true,
          ),
        );
      } else {
        AppSnackbar.showSnackbar(title: "Error", message: data['message']);
      }
    }).catchError((err) {
      debugPrint(err.toString());
      AppSnackbar.showSnackbar(title: "Error", message: err.toString());
      // AppSnackbar.showSnackbar(title: "Error", message: "Something went wrong please try again later!");
    });
  }
}
