import 'dart:async';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:bird_x/models/all_chats_model.dart';
import 'package:bird_x/services/chat_services.dart';
import 'package:bird_x/views/main_page_views/menu_views/chats_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatController extends GetxController {
  StreamController<List<ChatData>> chatStream = StreamController();
  ItemScrollController scrollController = ItemScrollController();
  // ScrollController scrollController = ScrollController();
  List<ChatData> chats = [];
  TextEditingController message = TextEditingController();
  final ChatServices _chatServices = ChatServices();
  void sendMessage({
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

      if (scrollController.isAttached) {
        scrollController.scrollTo(
          index: chats.length - 1,
          // scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      }
      message.clear();
      socket.emit(
        "stopTyping",
        roomId,
      );
      update();
    }
  }

  bool isTyping = false;
  bool isOnline = false;
  eventListening() {
    socket.on("isTyping", (data) {
      isTyping = true;
      isOnline = true;
      update();
      if (scrollController.isAttached) {
        scrollController.scrollTo(
          index: chats.length - 1,
          // scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      }
    });
    socket.on("stopTyping", (data) {
      isTyping = false;
      update();
    });
    socket.on("offline", (data) {
      isOnline = false;
      update();
    });

    socket.on("message", (data) {
      ChatData chatData = ChatData.fromJson(data);
      chats.add(chatData);

      chatStream.add(chats);
      if (scrollController.isAttached) {
        scrollController.scrollTo(
          index: chats.length - 1,
          // scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      }
    });
  }

  scrollToDown() {
    scrollController.scrollTo(
      index: chats.length - 1,
      // scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
  }
}
