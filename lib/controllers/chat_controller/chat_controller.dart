import 'dart:async';

import 'package:bird_x/models/all_chats_model.dart';
import 'package:bird_x/services/chat_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatController extends GetxController {
  final StreamController<List<ChatData>> chatStream = StreamController();
  final ItemScrollController scrollController = ItemScrollController();
  List<ChatData> chats = [];
  TextEditingController message = TextEditingController();
  final ChatServices _chatServices = ChatServices();
  void sendMessage(
    Socket socket, {
    required String senderId,
    required String receiverId,
    required String roomId,
  }) {
    if (message.text.isNotEmpty) {
      var messageData = _chatServices.sendMessage(
        message: message.text,
        senderId: senderId,
        receiverId: receiverId,
        roomId: roomId,
      );
      socket.emit("message", messageData);
      ChatData chatData = ChatData(
        createdOn: DateTime.now().toUtc().toString(),
        message: message.text,
        senderId: senderId,
        receiverId: receiverId,
        roomId: roomId,
      );
      chats.add(chatData);

      chatStream.add(chats);

      {
        scrollController.scrollTo(
          index: chats.length - 1,
          duration: const Duration(milliseconds: 500),
        );
      }

      message.clear();
    }
  }
}
