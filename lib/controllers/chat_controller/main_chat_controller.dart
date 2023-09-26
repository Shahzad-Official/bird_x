import 'package:bird_x/models/all_chats_model.dart';
import 'package:get/get.dart';

class MainChatController extends GetxController {
  bool isNewMessage = false;
  ChatData chatData = ChatData();
  getChatData(ChatData newData) {
    chatData = newData;
    update();
  }

  changeIsNewStatus(bool value) {
    isNewMessage = value;
    update();
  }
}
