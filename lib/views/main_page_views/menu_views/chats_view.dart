import 'dart:convert';

import 'package:bird_x/constants/api_constant.dart';
import 'package:bird_x/constants/app_spacing.dart';
import 'package:bird_x/main.dart';
import 'package:bird_x/models/all_chats_model.dart';
import 'package:bird_x/models/user_model.dart';
import 'package:bird_x/services/chat_services.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/utils/date_utils.dart';
import 'package:bird_x/views/chat_screens/chat_screen.dart';
import 'package:bird_x/views/notifications.dart/notifications.dart';
import 'package:bird_x/widgets/app_cached_image.dart';
import 'package:bird_x/widgets/app_shadowcontainer.dart';
import 'package:bird_x/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:socket_io_client/socket_io_client.dart';

Socket socket = io(
  ApiConstant.mainUrl,
  OptionBuilder().setTransports(['websocket']).disableAutoConnect().build(),
);

class ChatsView extends StatefulWidget {
  const ChatsView({Key? key}) : super(key: key);

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  final ChatServices _chatServices = ChatServices();
  LoginModel loginModel = LoginModel();
  bool isLoading = false;
  getData() async {
    setState(() {
      isLoading = true;
    });
    loginModel = LoginModel.fromJson(
      jsonDecode(
        box.get("userData"),
      ),
    );

    socket.emit(
      "updateStatus",
      {
        "userId": loginModel.data?.sId.toString(),
        "isOnline": true,
      },
    );

    await _chatServices.getAllUsers();

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    socket.connect();

    socket.onConnect((data) => debugPrint("user connected"));
    socket.onDisconnect((data) {
      socket.emit(
        "updateStatus",
        {
          "userId": loginModel.data?.sId.toString(),
          "isOnline": false,
        },
      );
      debugPrint("user disconnect");
    });
    socket.onError((data) => debugPrint("error on connection $data"));
    getData();
    super.initState();
  }

  @override
  void dispose() {
    socket.emit(
      "updateStatus",
      {
        "userId": loginModel.data?.sId.toString(),
        "isOnline": false,
      },
    );
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                  flex: 9,
                  child: AppText(
                    text: "Chats",
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Flexible(
                  child: InkWell(
                    onTap: () {
                      AppNavigation.to(context,
                          nextPage: const Notifications());
                    },
                    child: AppShadowcontainer(
                      child: SvgPicture.asset(
                        "assets/icons/bell.svg",
                      ),
                    ),
                  ),
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
          : Padding(
              padding: AppSpacing.defaultPadding,
              child: Column(
                children: [
                  AppSpacing.heigthSpace20,
                  _chatServices.allUsersModel.data == null ||
                          _chatServices.allUsersModel.data!.isEmpty
                      ? const Center(
                          child: AppText(
                            text: "NO Data found!",
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: _chatServices.allUsersModel.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: InkWell(
                                onTap: () {
                                  AppNavigation.to(
                                    context,
                                    nextPage: ChatScreen(
                                      userData: _chatServices
                                          .allUsersModel.data![index],
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 52,
                                  width: double.infinity,
                                  decoration:
                                      const BoxDecoration(color: Colors.white),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: AppCachedImage(
                                          url: _chatServices.allUsersModel
                                              .data![index].profile!,
                                          height: 52,
                                          width: 52,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          AppText(
                                            text:
                                                "${_chatServices.allUsersModel.data![index].firstName!} ${_chatServices.allUsersModel.data![index].lastName}",
                                            fontSize: 17,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          FutureBuilder<AllChatsModel>(
                                            future: _chatServices.getUserChats(
                                              _chatServices.allUsersModel
                                                  .data![index].sId
                                                  .toString(),
                                            ),
                                            builder: (context, snap) {
                                              if (snap.hasData) {
                                                return Row(
                                                  children: [
                                                    AppText(
                                                      text: snap.data == null ||
                                                              snap.data!.data ==
                                                                  null ||
                                                              snap.data!.data!
                                                                  .isEmpty
                                                          ? ""
                                                          : snap
                                                                      .data!
                                                                      .data!
                                                                      .last
                                                                      .senderId
                                                                      .toString() ==
                                                                  _chatServices
                                                                      .allUsersModel
                                                                      .data![
                                                                          index]
                                                                      .sId
                                                                      .toString()
                                                              ? snap.data!.data!
                                                                  .last.message
                                                                  .toString()
                                                              : "You: ${snap.data!.data!.last.message.toString()}",
                                                      fontSize: 15,
                                                    ),
                                                  ],
                                                );
                                              } else {
                                                return const AppText(
                                                    text: "loading...");
                                              }
                                            },
                                          ),
                                        ],
                                      ),
                                      const Spacer(),
                                      FutureBuilder<AllChatsModel>(
                                        future: _chatServices.getUserChats(
                                          _chatServices
                                              .allUsersModel.data![index].sId
                                              .toString(),
                                        ),
                                        builder: (context, snap) {
                                          if (snap.hasData) {
                                            return AppText(
                                              text: snap.data == null ||
                                                      snap.data!.data == null ||
                                                      snap.data!.data!.isEmpty
                                                  ? ""
                                                  : AppDateUtils.formatDate(
                                                      pattern: "hh:mm aa",
                                                      date: snap.data!.data!
                                                          .last.createdOn
                                                          .toString()),
                                              color: const Color(0xff5F5F5F),
                                              fontSize: 12,
                                            );
                                          } else {
                                            return const AppText(
                                                text: "loading...");
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
    );
  }
}
