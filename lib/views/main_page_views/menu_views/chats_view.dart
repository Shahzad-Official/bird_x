import 'dart:convert';

import 'package:bird_x/constants/app_spacing.dart';
import 'package:bird_x/controllers/chat_controller/main_chat_controller.dart';
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
import 'package:get/get.dart';

class ChatsView extends StatefulWidget {
  const ChatsView({Key? key}) : super(key: key);

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  final MainChatController _chatController = Get.put(MainChatController());
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

    await _chatServices.getAllUsers();

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const AppText(
          text: "Chats",
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              top: 5,
              bottom: 15,
            ),
            child: InkWell(
              onTap: () {
                AppNavigation.to(context, nextPage: const Notifications());
              },
              child: AppShadowcontainer(
                child: SvgPicture.asset(
                  "assets/icons/bell.svg",
                  height: 20,
                  width: 20,
                ),
              ),
            ),
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: AppSpacing.defaultPadding,
              child: Column(
                children: [
                  _chatServices.allUsersModel.data == null || _chatServices.allUsersModel.data!.isEmpty
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
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              onTap: () {
                                AppNavigation.to(
                                  context,
                                  nextPage: ChatScreen(
                                    userData: _chatServices.allUsersModel.data![index],
                                  ),
                                );
                                _chatController.changeIsNewStatus(false);
                              },
                              leading: SizedBox(
                                height: 52,
                                width: 52,
                                child: AppCachedImage(
                                  shape: BoxShape.circle,
                                  url: _chatServices.allUsersModel.data![index].profile!,
                                  height: 52,
                                  width: 52,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: AppText(
                                text: "${_chatServices.allUsersModel.data![index].firstName!} ${_chatServices.allUsersModel.data![index].lastName}",
                                fontSize: 17,
                                fontWeight: FontWeight.w500,
                              ),
                              subtitle: FutureBuilder<ChatData>(
                                future: _chatServices.getUserChats(
                                  _chatServices.allUsersModel.data![index].sId.toString(),
                                ),
                                builder: (context, snap) {
                                  if (snap.hasData) {
                                    return GetBuilder<MainChatController>(
                                      init: MainChatController(),
                                      builder: (_) {
                                        return AppText(
                                          maxLines: 1,
                                          text: _.isNewMessage && _.chatData.senderId == _chatServices.allUsersModel.data![index].sId.toString()
                                              ? _.chatData.message.toString()
                                              : snap.data == null || snap.data!.message == null
                                                  ? "No messages yet"
                                                  : snap.data!.senderId.toString() == _chatServices.allUsersModel.data![index].sId.toString()
                                                      ? snap.data!.message.toString()
                                                      : "You: ${snap.data!.message.toString()}",
                                          fontSize: 15,
                                          fontWeight: _.isNewMessage && _.chatData.senderId == _chatServices.allUsersModel.data![index].sId.toString() ? FontWeight.w700 : null,
                                          overFlow: TextOverflow.ellipsis,
                                          fontStyle: snap.data == null || snap.data == null ? FontStyle.italic : null,
                                        );
                                      },
                                    );
                                  } else {
                                    return const AppText(text: "loading...");
                                  }
                                },
                              ),
                              trailing: FutureBuilder<ChatData>(
                                future: _chatServices.getUserChats(
                                  _chatServices.allUsersModel.data![index].sId.toString(),
                                ),
                                builder: (context, snap) {
                                  if (snap.hasData) {
                                    return AppText(
                                      text: snap.data == null || snap.data == null || snap.data!.createdOn == null
                                          ? ""
                                          : AppDateUtils.formatDate(pattern: "hh:mm aa", date: snap.data!.createdOn.toString()),
                                      color: const Color(0xff5F5F5F),
                                      fontSize: 12,
                                    );
                                  } else {
                                    return const AppText(text: "loading...");
                                  }
                                },
                              ),
                            );
                            // return Padding(
                            //   padding: const EdgeInsets.only(bottom: 20),
                            //   child: InkWell(
                            //     onTap: () {
                            //       setState(() {
                            //         isNewMessage = false;
                            //       });
                            //       AppNavigation.to(
                            //         context,
                            //         nextPage: ChatScreen(
                            //           userData: _chatServices.allUsersModel.data![index],
                            //         ),
                            //       );
                            //     },
                            //     child: Container(
                            //       height: 52,
                            //       width: double.infinity,
                            //       decoration: const BoxDecoration(color: Colors.white),
                            //       child: Row(
                            //         crossAxisAlignment: CrossAxisAlignment.start,
                            //         children: [
                            //           ClipRRect(
                            //             borderRadius: BorderRadius.circular(30),
                            //             child: AppCachedImage(
                            //               url: _chatServices.allUsersModel.data![index].profile!,
                            //               height: 52,
                            //               width: 52,
                            //               fit: BoxFit.cover,
                            //             ),
                            //           ),
                            //           const SizedBox(
                            //             width: 15,
                            //           ),
                            //           Column(
                            //             crossAxisAlignment: CrossAxisAlignment.start,
                            //             children: [
                            //               AppText(
                            //                 text: "${_chatServices.allUsersModel.data![index].firstName!} ${_chatServices.allUsersModel.data![index].lastName}",
                            //                 fontSize: 17,
                            //                 fontWeight: FontWeight.w500,
                            //               ),
                            //               FutureBuilder<AllChatsModel>(
                            //                 future: _chatServices.getUserChats(
                            //                   _chatServices.allUsersModel.data![index].sId.toString(),
                            //                 ),
                            //                 builder: (context, snap) {
                            //                   if (snap.hasData) {
                            //                     return AppText(
                            //                       maxLines: 1,
                            //                       text: isNewMessage && chatData.senderId == _chatServices.allUsersModel.data![index].sId.toString()
                            //                           ? chatData.message.toString()
                            //                           : snap.data == null || snap.data!.data == null || snap.data!.data!.isEmpty
                            //                               ? ""
                            //                               : snap.data!.data!.last.senderId.toString() == _chatServices.allUsersModel.data![index].sId.toString()
                            //                                   ? snap.data!.data!.last.message.toString()
                            //                                   : "You: ${snap.data!.data!.last.message.toString()}",
                            //                       fontSize: 15,
                            //                       fontWeight: isNewMessage ? FontWeight.w600 : null,
                            //                       overFlow: TextOverflow.ellipsis,
                            //                     );
                            //                   } else {
                            //                     return const AppText(text: "loading...");
                            //                   }
                            //                 },
                            //               ),
                            //             ],
                            //           ),
                            //           const Spacer(),
                            //           FutureBuilder<AllChatsModel>(
                            //             future: _chatServices.getUserChats(
                            //               _chatServices.allUsersModel.data![index].sId.toString(),
                            //             ),
                            //             builder: (context, snap) {
                            //               if (snap.hasData) {
                            //                 return AppText(
                            //                   text: snap.data == null || snap.data!.data == null || snap.data!.data!.isEmpty
                            //                       ? ""
                            //                       : AppDateUtils.formatDate(pattern: "hh:mm aa", date: snap.data!.data!.last.createdOn.toString()),
                            //                   color: const Color(0xff5F5F5F),
                            //                   fontSize: 12,
                            //                 );
                            //               } else {
                            //                 return const AppText(text: "loading...");
                            //               }
                            //             },
                            //           ),
                            //         ],
                            //       ),
                            //     ),
                            //   ),
                            // );
                          },
                        ),
                ],
              ),
            ),
    );
  }
}
