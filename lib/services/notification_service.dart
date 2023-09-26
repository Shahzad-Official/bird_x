import 'dart:convert';

import 'package:bird_x/constants/api_constant.dart';
import 'package:bird_x/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class NotificationService {
  String get token => box.get("token");
  updateFcm() async {
    var body = jsonEncode(
      {
        "fcmToken": box.get("fcm").toString(),
      },
    );
    await post(
      Uri.parse(ApiConstant.baseUrl + ApiConstant.updateFcm),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    ).then((value) {
      print(value.body);
    }).catchError((err) {
      debugPrint("update fcm error=> $err");
    });
  }
}
