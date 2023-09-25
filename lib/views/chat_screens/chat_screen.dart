import 'dart:convert';

import 'package:bird_x/constants/app_colors.dart';
import 'package:bird_x/controllers/chat_controller/chat_controller.dart';
import 'package:bird_x/controllers/main_page_controllers/main_page_controller.dart';
import 'package:bird_x/main.dart';
import 'package:bird_x/models/all_chats_model.dart';
import 'package:bird_x/models/user_model.dart';
import 'package:bird_x/services/chat_services.dart';
import 'package:bird_x/services/registration_services.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/utils/date_utils.dart';
import 'package:bird_x/views/main_page_views/main_page.dart';
import 'package:bird_x/views/main_page_views/menu_views/chats_view.dart';
import 'package:bird_x/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ChatScreen extends StatefulWidget {
  final UserData userData;
  const ChatScreen({super.key, required this.userData});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController _chatController = Get.put(ChatController());
  ChatData? myChatData;

  bool isTyping = false;

  final ChatServices _chatServices = ChatServices();
  Map<String, dynamic> userData = {};
  bool isLoading = false;
  getData() async {
    setState(() {
      isLoading = true;
    });
    userData = jsonDecode(box.get("userData"));

    await _chatServices.createRoom(
      senderId: userData['data']['_id'].toString(),
      receiverId: widget.userData.sId.toString(),
    );

    socket.on("isTyping", (data) {
      setState(() {
        isTyping = true;
      });
      _chatController.scrollController.scrollTo(
        index: _chatController.chats.length - 1,
        duration: const Duration(milliseconds: 500),
      );
    });
    socket.on("stopTyping", (data) {
      isTyping = false;
    });

    socket.on("message", (data) {
      ChatData chatData = ChatData.fromJson(data);
      _chatController.chats.add(chatData);

      _chatController.chatStream.add(_chatController.chats);
      {
        _chatController.scrollController.scrollTo(
          index: _chatController.chats.length - 1,
          duration: const Duration(milliseconds: 500),
        );
      }
    });
    await _chatServices
        .getRoomChats(_chatServices.roomData.data!.sId.toString());
    _chatController.chats = _chatServices.allChatsModel.data!;
    _chatController.chatStream.add(_chatController.chats);
    myChatData = _chatServices.allChatsModel.data == null ||
            _chatServices.allChatsModel.data!.isEmpty
        ? null
        : _chatServices.allChatsModel.data?.lastWhere(
            (element) =>
                element.senderId.toString() == widget.userData.sId.toString(),
            orElse: () => ChatData(),
          );
    setState(() {
      isLoading = false;
    });
  }

  bool isScrollAble = false;
  @override
  void initState() {
    getData();

    super.initState();
  }

  @override
  void dispose() {
    Get.delete<ChatController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.find<MainPageController>().selectedIndex = 1;
        AppNavigation.offAll(
          context,
          nextPage: const MainPage(),
        );
        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BackButton(
                        onPressed: () {
                          Get.find<MainPageController>().selectedIndex = 1;
                          AppNavigation.offAll(
                            context,
                            nextPage: const MainPage(),
                          );
                        },
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          AppText(
                            text:
                                "${widget.userData.firstName!} ${widget.userData.lastName}",
                            fontSize: 18,
                          ),
                          FutureBuilder(
                            future: RegistrationServices()
                                .getUserData(widget.userData.sId.toString()),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return AppText(
                                  text: snapshot.data == null ||
                                          snapshot.data!.isOnline == null ||
                                          snapshot.data!.lastActive == null
                                      ? ""
                                      : snapshot.data!.isOnline!
                                          ? "Online"
                                          : "Last active: ${AppDateUtils.formatDate(
                                              pattern: "hh:mm aa",
                                              date: snapshot.data!.lastActive
                                                  .toString(),
                                            )}",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w300,
                                  color: snapshot.data!.isOnline!
                                      ? Colors.green
                                      : null,
                                );
                              } else {
                                return const AppText(
                                  text: "",
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : GetBuilder<ChatController>(
                init: ChatController(),
                builder: (_) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: StreamBuilder<List<ChatData>>(
                            stream: _.chatStream.stream,
                            builder: (context, snapshot) {
                              if (snapshot.data == null ||
                                  snapshot.data!.isEmpty) {
                                return const Center(
                                  child: AppText(
                                    text: "NO Data Found",
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                );
                              } else {
                                return ScrollablePositionedList.builder(
                                  itemScrollController: _.scrollController,
                                  itemCount: _.chats.length + 1,
                                  itemBuilder: (context, index) {
                                    if (index == _.chats.length) {
                                      return Align(
                                        alignment: Alignment.centerLeft,
                                        child: !isTyping
                                            ? const SizedBox()
                                            : Container(
                                                margin:
                                                    const EdgeInsets.all(8.0),
                                                height: 35,
                                                width: 50,
                                                decoration: const BoxDecoration(
                                                  color: AppColors.primaryColor,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(16),
                                                    bottomRight:
                                                        Radius.circular(16),
                                                    topRight:
                                                        Radius.circular(16),
                                                  ),
                                                ),
                                                child: const Center(
                                                  child: SpinKitThreeBounce(
                                                    size: 15,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                      );
                                    } else {
                                      final message =
                                          _.chats[index].message.toString();
                                      final alignment =
                                          _.chats[index].senderId ==
                                                  userData['data']['_id']
                                              ? CrossAxisAlignment.end
                                              : CrossAxisAlignment.start;
                                      final textColor =
                                          alignment == CrossAxisAlignment.end
                                              ? const Color(0xff212121)
                                              : Colors.white;
                                      final borderRadius = alignment ==
                                              CrossAxisAlignment.end
                                          ? const BorderRadius.only(
                                              bottomLeft: Radius.circular(16),
                                              bottomRight: Radius.circular(16),
                                              topLeft: Radius.circular(16),
                                            )
                                          : const BorderRadius.only(
                                              bottomLeft: Radius.circular(16),
                                              bottomRight: Radius.circular(16),
                                              topRight: Radius.circular(16),
                                            );

                                      final formattedTime =
                                          AppDateUtils.formatDate(
                                        pattern: "hh:mm aa",
                                        date:
                                            _.chats[index].createdOn.toString(),
                                      );
                                      return Column(
                                        crossAxisAlignment: alignment,
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.all(8.0),
                                            padding: const EdgeInsets.all(12.0),
                                            constraints: BoxConstraints(
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.7),
                                            decoration: BoxDecoration(
                                              color: alignment ==
                                                      CrossAxisAlignment.end
                                                  ? const Color(0xffF0F0F1)
                                                  : AppColors.primaryColor,
                                              borderRadius: borderRadius,
                                            ),
                                            child: Text(
                                              message,
                                              style:
                                                  TextStyle(color: textColor),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, right: 10),
                                            child: AppText(
                                              text: formattedTime,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ],
                                      );
                                    }
                                  },
                                );
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 60,
                                  decoration: const BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.1),
                                        offset: Offset(0, 4),
                                        blurRadius: 20,
                                        spreadRadius: 0,
                                      ),
                                    ],
                                  ),
                                  child: Focus(
                                    onFocusChange: (value) {
                                      if (value) {
                                        socket.emit(
                                          "isTyping",
                                          _chatServices.roomData.data!.sId
                                              .toString(),
                                        );
                                      } else {
                                        socket.emit(
                                          "stopTyping",
                                          _chatServices.roomData.data!.sId
                                              .toString(),
                                        );
                                      }
                                    },
                                    child: TextFormField(
                                      controller: _chatController.message,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelStyle: GoogleFonts.poppins(),
                                        hintText: "Write a message",
                                        hintStyle: GoogleFonts.roboto(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w400,
                                          color: const Color(0xff4C4C4C),
                                        ),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 15.0,
                                                horizontal: 25.0),
                                        suffixIcon: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: InkWell(
                                            onTap: () {
                                              _chatController.sendMessage(
                                                socket,
                                                receiverId: widget.userData.sId
                                                    .toString(),
                                                senderId: userData['data']
                                                    ['_id'],
                                                roomId: _chatServices
                                                    .roomData.data!.sId
                                                    .toString(),
                                              );
                                            },
                                            child: Container(
                                              height: 40,
                                              width: 40,
                                              decoration: const BoxDecoration(
                                                  color: AppColors.primaryColor,
                                                  shape: BoxShape.circle),
                                              child: Center(
                                                child: SvgPicture.asset(
                                                    "assets/icons/send.svg"),
                                              ),
                                            ),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(
                                              color:
                                                  Colors.black.withOpacity(0.1),
                                              width: 1),
                                          borderRadius:
                                              BorderRadius.circular(30),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
      ),
    );
  }
}
