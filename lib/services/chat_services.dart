import 'dart:convert';

import 'package:bird_x/constants/api_constant.dart';
import 'package:bird_x/main.dart';
import 'package:bird_x/models/all_chats_model.dart';
import 'package:bird_x/models/all_users_model.dart';
import 'package:bird_x/models/room_model.dart';
import 'package:bird_x/utils/app_snackbar.dart';
import 'package:bird_x/views/main_page_views/main_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ChatServices {
  String get token => box.get("token");
  RoomModel roomData = RoomModel();
  createRoom({
    required String senderId,
    required String receiverId,
  }) async {
    var body = jsonEncode({
      "senderId": senderId,
      "receiverId": receiverId,
    });
    await post(
      Uri.parse(ApiConstant.baseUrl + ApiConstant.createRoom),
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    ).then((value) {
      var data = jsonDecode(value.body);
      if (value.statusCode == 200) {
        roomData = RoomModel.fromJson(data);
        socket.emit("join_room", roomData.data!.sId.toString());
        socket.emit(
          "online",
          roomData.data!.sId.toString(),
        );
      } else {
        AppSnackbar.showSnackbar(title: "Error", message: data['message']);
      }
    }).catchError((err) {
      debugPrint(err.toString());
      // AppSnackbar.showSnackbar(title: "Error", message: err.toString());
    });
  }

  String sendMessage({
    required String senderId,
    required String receiverId,
    required String roomId,
    required String message,
  }) {
    var body = jsonEncode({
      "senderId": senderId,
      "receiverId": receiverId,
      "roomId": roomId,
      "message": message,
    });
    return body;
  }

  AllUsersModel allUsersModel = AllUsersModel();
  getAllUsers() async {
    await get(
      Uri.parse(ApiConstant.baseUrl + ApiConstant.getUsers),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    ).then((value) {
      var data = jsonDecode(value.body);
      allUsersModel = AllUsersModel.fromJson(data);
    }).catchError((err) {
      debugPrint(err.toString());
      // AppSnackbar.showSnackbar(title: "Error", message: err.toString());
    });
  }

  AllChatsModel allChatsModel = AllChatsModel();
  getRoomChats(String roomId) async {
    await get(
      Uri.parse("${ApiConstant.baseUrl}${ApiConstant.roomChats}?roomId=$roomId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    ).then((value) {
      var data = jsonDecode(value.body);
      allChatsModel = AllChatsModel.fromJson(data);
    }).catchError((err) {
      debugPrint(err.toString());
      // AppSnackbar.showSnackbar(title: "Error", message: err.toString());
    });
  }

  Future<ChatData> getUserChats(String receiverId) async {
    ChatData chatData = ChatData();
    await get(
      Uri.parse("${ApiConstant.baseUrl}${ApiConstant.lastMessage}?receiverId=$receiverId"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    ).then((value) {
      var data = jsonDecode(value.body);
      if (data['data'] != null) {
        chatData = ChatData.fromJson(data['data']);
      } else {
        chatData = ChatData();
      }
    }).catchError((err) {
      debugPrint(err.toString());
      // AppSnackbar.showSnackbar(title: "Error", message: err.toString());
    });
    return chatData;
  }
}
