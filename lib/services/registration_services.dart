import 'dart:convert';

import 'package:bird_x/constants/api_constant.dart';
import 'package:bird_x/main.dart';
import 'package:bird_x/models/user_model.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/utils/app_snackbar.dart';
import 'package:bird_x/views/main_page_views/main_page.dart';
import 'package:bird_x/views/registration_views/otp_verification.dart';
import 'package:bird_x/views/registration_views/reset_password.dart';
import 'package:bird_x/views/registration_views/successfull_registration.dart';
import 'package:bird_x/widgets/google_dropdown.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
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
    required String mobileCode,
    required String profile,
    required String address,
    required String latitude,
    required String longitude,
    required String gender,
    required String refCode,
  }) async {
    var body = jsonEncode({
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "password": password,
      "mobile": mobile,
      "mobileCode": mobileCode,
      "profile": profile,
      "address": address,
      "latitude": latitude,
      "longitude": longitude,
      "gender": gender,
      "referrer": refCode,
    });
    await post(
      Uri.parse(ApiConstant.baseUrl + ApiConstant.signUp),
      headers: {"Content-Type": "application/json"},
      body: body,
    ).then((value) {
      var data = jsonDecode(value.body);

      if (value.statusCode == 201) {
        box.put("referralCode", null);
        box.put("token", data['token']);
        box.put("tempPass", password);

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
    });
  }

  login(
    context, {
    required String email,
    required String password,
    bool isAfterVerification = false,
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
    ).then((value) async {
      var data = jsonDecode(value.body);

      if (value.statusCode == 200) {
        box.put("token", data['token']);
        box.put("userData", value.body);

        box.put("isLoggedIn", true);
        if (!isAfterVerification) {
          AppSnackbar.showSnackbar(title: "Success", message: data['message']);
          AppNavigation.offAll(
            context,
            nextPage: const MainPage(),
          );
        }
      } else if (value.statusCode == 401) {
        await sendOtp(
          context,
          email: email,
          fromLogin: true,
        );
        AppSnackbar.showSnackbar(title: "Error", message: data['message']);
      } else {
        AppSnackbar.showSnackbar(title: "Error", message: data['message']);
      }
    }).catchError((err) {
      debugPrint(err.toString());
      AppSnackbar.showSnackbar(title: "Error", message: err.toString());
      // AppSnackbar.showSnackbar(title: "Error", message: "Something went wrong please try again later!");
    });
  }

  googleLogin(
    context,
  ) async {
    await GoogleSignIn().signOut();
    await GoogleSignIn().signIn().then(
      (value) async {
        var body = jsonEncode({
          "email": value?.email,
          "firstName": value?.displayName?.split(" ").first,
          "lastName": value?.displayName?.split(" ").last,
          "imageUrl": value!.photoUrl ?? " ",
          "referrer": box.get("referralCode") ?? " ",
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
            box.put("referralCode", null);
            box.put("token", data['token']);
            if (data['data']['gender'] == null || data['data']['gender'].toString().trim().isEmpty) {
              box.put("isLoggedIn", false);

              showModalBottomSheet(
                showDragHandle: true,
                context: context,
                builder: (context) {
                  return const GoogleDropdown();
                },
              );
            } else {
              box.put("isLoggedIn", true);
              box.put("userData", value.body);
              AppSnackbar.showSnackbar(title: "Message", message: data['message']);
              AppNavigation.offAll(
                context,
                nextPage: const MainPage(),
              );
            }
          } else {
            AppSnackbar.showSnackbar(title: "Error", message: data['message']);
          }
        }).catchError((err) {
          debugPrint(err);
          AppSnackbar.showSnackbar(title: "Error", message: err.toString());
        });
      },
    );
  }

  sendOtp(
    context, {
    required String email,
    bool fromLogin = false,
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
        if (!fromLogin) {
          AppSnackbar.showSnackbar(title: "Success", message: data['message']);
        }

        AppNavigation.offAll(
          context,
          nextPage: OtpVerification(
            email: email,
            isForgetEmail: fromLogin ? false : true,
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
          login(
            context,
            email: email,
            password: box.get("tempPass").toString(),
            isAfterVerification: true,
          );
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

  forgetPassword(
    context, {
    required String email,
    required String password,
  }) async {
    var body = jsonEncode({
      "email": email,
      "password": password,
    });
    await post(
      Uri.parse(ApiConstant.baseUrl + ApiConstant.forgetPassword),
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

  updatePassword(
    context, {
    required String email,
    required String password,
    required String oldPassword,
  }) async {
    var body = jsonEncode({
      "email": email,
      "password": password,
      "oldPassword": oldPassword,
    });
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
        AppNavigation.back(context);
      } else {
        AppSnackbar.showSnackbar(title: "Error", message: data['message']);
      }
    }).catchError((err) {
      debugPrint(err.toString());
      AppSnackbar.showSnackbar(title: "Error", message: err.toString());
      // AppSnackbar.showSnackbar(title: "Error", message: "Something went wrong please try again later!");
    });
  }

  updateProfile(
    context, {
    String? firstName,
    String? lastName,
    String? password,
    String? mobile,
    String? mobileCode,
    String? profile,
    String? address,
    String? latitude,
    String? longitude,
    String? gender,
    String? refCode,
  }) async {
    var body = jsonEncode({
      "firstName": firstName,
      "lastName": lastName,
      "password": password,
      "mobile": mobile,
      "mobileCode": mobileCode,
      "profile": profile,
      "address": address,
      "latitude": latitude,
      "longitude": longitude,
      "gender": gender,
      "referrer": refCode,
    });
    await post(
      Uri.parse(ApiConstant.baseUrl + ApiConstant.updateProfile),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    ).then((value) {
      var data = jsonDecode(value.body);
      if (value.statusCode == 200) {
        box.put("referralCode", null);
        box.put("token", data['token']);
        box.put("isLoggedIn", true);
        box.put("userData", value.body);
        AppSnackbar.showSnackbar(title: "Message", message: data['message']);
        AppNavigation.offAll(
          context,
          nextPage: const MainPage(),
        );
      } else {
        AppNavigation.back(context);
        AppSnackbar.showSnackbar(title: "Message", message: data['message']);
      }
    }).catchError((err) {
      debugPrint(err.toString());
      AppSnackbar.showSnackbar(title: "Error", message: err.toString());
      // AppSnackbar.showSnackbar(title: "Error", message: "Something went wrong please try again later!");
    });
  }

  Future<UserData> getUserData(String userId) async {
    UserData userData = UserData();
    await get(
      Uri.parse("${ApiConstant.baseUrl}${ApiConstant.getUserData}?userId=$userId"),
      headers: {
        "Content-Type": "application/json",
      },
    ).then((value) {
      var data = jsonDecode(value.body);
      if (value.statusCode == 200) {
        userData = UserData.fromJson(data['data']);
      }
    }).catchError((err) {
      AppSnackbar.showSnackbar(title: "Error", message: err.toString());
    });
    return userData;
  }

  static Future<String> generateLink(inviteCode) async {
    String link = "";
    String url = "https://hexon.page.link";
    DynamicLinkParameters linkParameters = DynamicLinkParameters(
        uriPrefix: url,
        link: Uri.parse("$url/invite?code=$inviteCode"),
        androidParameters: const AndroidParameters(
          packageName: "online.hexon.petx",
        ),
        socialMetaTagParameters: SocialMetaTagParameters(
          title: "Share the Pet Love: Grow Our Pack with PetX!",
          description: "Share PetX with friends, and let's make our pet-loving community even more purr-fect together! 🐾❤️",
          imageUrl: Uri.parse("https://raw.githubusercontent.com/Shahzad-Official/Public-Files/main/17195464_5847918%201.png"),
        ));
    await FirebaseDynamicLinks.instance.buildShortLink(linkParameters).then((value) {
      link = value.shortUrl.toString();
    }).catchError((err) {
      debugPrint(err.toString());
    });
    return link;
  }
}
