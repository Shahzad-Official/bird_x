import 'dart:async';
import 'dart:convert';

import 'package:bird_x/constants/api_constant.dart';
import 'package:bird_x/constants/app_colors.dart';
import 'package:bird_x/main.dart';
import 'package:bird_x/models/all_chats_model.dart';
import 'package:bird_x/models/user_model.dart';
import 'package:bird_x/services/chat_services.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatScreen extends StatefulWidget {
  final UserData userData;
  const ChatScreen({super.key, required this.userData});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final StreamController<List<ChatData>> _chatStream = StreamController<List<ChatData>>();
  Socket socket = io(
    ApiConstant.mainUrl,
    OptionBuilder().setTransports(['websocket']).disableAutoConnect().build(),
  );
  final TextEditingController _messageController = TextEditingController();
  List<ChatData> chats = [];
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

    socket.connect();
    socket.onConnect((data) => debugPrint("user connected"));
    socket.onDisconnect((data) => debugPrint("user disconnect"));
    socket.onError((data) => debugPrint("error on connection $data"));
    socket.emit("join_room", _chatServices.roomData.data!.sId.toString());
    socket.on("message", (data) {
      debugPrint("message data is $data");
    });
    await _chatServices.getRoomChats(_chatServices.roomData.data!.sId.toString());
    chats = _chatServices.allChatsModel.data!;
    _chatStream.add(chats);
    setState(() {
      isLoading = false;
    });
  }

  void _sendMessage() {
    String messageText = _messageController.text;
    if (messageText.isNotEmpty) {
      var messageData = _chatServices.sendMessage(
        message: messageText,
        senderId: userData['data']['_id'].toString(),
        receiverId: widget.userData.sId.toString(),
        roomId: _chatServices.roomData.data!.sId.toString(),
      );
      socket.emit("message", messageData);

      _messageController.clear();
    }
  }

  @override
  void initState() {
    getData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(110),
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
                    GestureDetector(
                        onTap: () {
                          AppNavigation.back(context);
                        },
                        child: const Icon(Icons.arrow_back)),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        AppText(
                          text: "${widget.userData.firstName!} ${widget.userData.lastName}",
                          fontSize: 18,
                        ),
                        const AppText(
                          text: "Last active: 02:11",
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<ChatData>>(
                stream: _chatStream.stream,
                builder: (context, snapshot) {
                  if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return Center(
                      child: AppText(
                        text: "NO Data Found",
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final message = snapshot.data![index].message.toString();
                      final alignment = snapshot.data![index].senderId == userData['_id'] ? CrossAxisAlignment.start : CrossAxisAlignment.end;
                      final textColor = alignment == CrossAxisAlignment.start ? const Color(0xff212121) : Colors.white;
                      final borderRadius = alignment == CrossAxisAlignment.start
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

                      final time = DateTime.parse(snapshot.data![index].createdOn.toString());
                      final formattedTime = DateFormat.Hm().format(time);
                      return Column(
                        crossAxisAlignment: alignment,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(8.0),
                            padding: const EdgeInsets.all(12.0),
                            decoration: BoxDecoration(color: alignment == CrossAxisAlignment.start ? const Color(0xffF0F0F1) : AppColors.primaryColor, borderRadius: borderRadius),
                            child: Text(
                              message,
                              style: TextStyle(color: textColor),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: AppText(
                              text: formattedTime,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      );
                    },
                  );
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
                      child: TextFormField(
                        controller: _messageController,
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
                          contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 25.0),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: InkWell(
                              onTap: () {
                                _sendMessage();
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: const BoxDecoration(color: AppColors.primaryColor, shape: BoxShape.circle),
                                child: Center(
                                  child: SvgPicture.asset("assets/icons/send.svg"),
                                ),
                              ),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black.withOpacity(0.1), width: 1),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black.withOpacity(0.1), width: 1),
                            borderRadius: BorderRadius.circular(30),
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
      ),
    );
  }
}
