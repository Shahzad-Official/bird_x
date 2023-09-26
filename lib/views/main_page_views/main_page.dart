import 'package:bird_x/constants/api_constant.dart';
import 'package:bird_x/constants/app_colors.dart';
import 'package:bird_x/controllers/chat_controller/main_chat_controller.dart';
import 'package:bird_x/controllers/main_page_controllers/main_page_controller.dart';
import 'package:bird_x/main.dart';
import 'package:bird_x/models/all_chats_model.dart';
import 'package:bird_x/services/local_notification_service.dart';
import 'package:bird_x/services/notification_service.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/views/add_product/add_product.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart';

Socket socket = io(
  ApiConstant.mainUrl,
  OptionBuilder().setTransports(['websocket']).disableAutoConnect().build(),
);

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final MainChatController _chatController = Get.put(MainChatController());
  final MainPageController _controller = Get.put(MainPageController());
  late PageController _pageController;

  @override
  void initState() {
    _pageController = PageController(
      initialPage: _controller.selectedIndex,
    );
    socket.connect();
    socket.onConnect((data) => debugPrint("user connected"));
    socket.onDisconnect((data) {
      debugPrint("user disconnect");
    });
    socket.onError((data) => debugPrint("error on connection $data"));
    FirebaseMessaging.instance.getToken().then((value) {
      if (box.get("fcm") == null || box.get("fcm") != value) {
        box.put("fcm", value);
        NotificationService().updateFcm();
      }
    });

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) {
        debugPrint("FirebaseMessaging.instance.getInitialMessage");
        if (message != null) {
          if (message.notification != null) {
            if (message.notification!.title.toString().toLowerCase().contains("message")) {
              ChatData chatData = ChatData.fromJson(message.data);

              _chatController.changeIsNewStatus(true);
              _chatController.getChatData(chatData);
              Get.find<MainPageController>().selectedIndex = 1;
              AppNavigation.offAll(
                context,
                nextPage: const MainPage(),
              );
            }
          }
        }
      },
    );

    FirebaseMessaging.onMessage.listen(
      (message) {
        debugPrint("FirebaseMessaging.onMessage.listen");
        if (message.notification != null) {
          ChatData chatData = ChatData.fromJson(message.data);

          _chatController.changeIsNewStatus(true);
          _chatController.getChatData(chatData);
          LocalNotificationService.createanddisplaynotification(message);
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) {
        debugPrint("FirebaseMessaging.onMessageOpenedApp.listen");

        if (message.notification != null) {
          debugPrint(message.data.toString());
          if (message.notification!.title.toString().toLowerCase().contains("message")) {
            Get.find<MainPageController>().selectedIndex = 1;
            AppNavigation.offAll(
              context,
              nextPage: const MainPage(),
            );
          }
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<MainPageController>(
        init: MainPageController(),
        builder: (controller) {
          return PageView.builder(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: (value) {
              controller.changeIndex(value);
            },
            itemCount: controller.allPages.length,
            itemBuilder: (context, index) {
              return controller.allPages[index];
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AppNavigation.to(context, nextPage: const AddProduct());
        },
        child: SvgPicture.asset(
          "assets/icons/add.svg",
          height: 20,
          width: 20,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: GetBuilder<MainPageController>(
        init: MainPageController(),
        builder: (_) {
          return NavigationBar(
            selectedIndex: _.selectedIndex,
            onDestinationSelected: (value) {
              _.changeIndex(value);
              _pageController.animateToPage(
                value,
                curve: Curves.ease,
                duration: const Duration(
                  milliseconds: 400,
                ),
              );
            },
            destinations: [
              NavigationDestination(
                icon: SvgPicture.asset(
                  "assets/icons/home.svg",
                  height: 25,
                  width: 25,
                  // ignore: deprecated_member_use
                  color: _.selectedIndex == 0 ? AppColors.primaryColor : Colors.black,
                ),
                label: "Home",
              ),
              NavigationDestination(
                icon: SvgPicture.asset(
                  "assets/icons/chats.svg",
                  height: 30,
                  width: 30,
                  // ignore: deprecated_member_use
                  color: _.selectedIndex == 1 ? AppColors.primaryColor : Colors.black,
                ),
                label: "Chats",
              ),
              NavigationDestination(
                icon: SvgPicture.asset(
                  "assets/icons/wishlist.svg",
                  height: 30,
                  width: 30,
                  // ignore: deprecated_member_use
                  color: _.selectedIndex == 2 ? AppColors.primaryColor : Colors.black,
                ),
                label: "WishList",
              ),
              NavigationDestination(
                icon: SvgPicture.asset(
                  "assets/icons/profile.svg",
                  height: 30,
                  width: 30,
                  // ignore: deprecated_member_use
                  color: _.selectedIndex == 3 ? AppColors.primaryColor : Colors.black,
                ),
                label: "Profile",
              ),
            ],
          );
          // return SalomonBottomBar(
          //   currentIndex: _.selectedIndex,
          //   onTap: (value) {
          //     _.changeIndex(value);
          //   },
          //   items: [
          //     SalomonBottomBarItem(
          //       icon: SvgPicture.asset(
          //         "assets/icons/home.svg",
          //         height: 30,
          //         width: 30,
          //         // ignore: deprecated_member_use
          //         color: _.selectedIndex == 0 ? AppColors.primaryColor : Colors.black,
          //       ),
          //       title: const AppText(
          //         text: "Home",
          //       ),
          //     ),
          //     SalomonBottomBarItem(
          //       icon: SvgPicture.asset(
          //         "assets/icons/chats.svg",
          //         height: 30,
          //         width: 30,
          //         // ignore: deprecated_member_use
          //         color: _.selectedIndex == 1 ? AppColors.primaryColor : Colors.black,
          //       ),
          //       title: const AppText(
          //         text: "Chats",
          //       ),
          //     ),
          //     SalomonBottomBarItem(
          //       icon: SvgPicture.asset(
          //         "assets/icons/wishlist.svg",
          //         height: 30,
          //         width: 30,
          //         // ignore: deprecated_member_use
          //         color: _.selectedIndex == 2 ? AppColors.primaryColor : Colors.black,
          //       ),
          //       title: const AppText(
          //         text: "WishList",
          //       ),
          //     ),
          //     SalomonBottomBarItem(
          //       icon: SvgPicture.asset(
          //         "assets/icons/profile.svg",
          //         height: 30,
          //         width: 30,
          //         // ignore: deprecated_member_use
          //         color: _.selectedIndex == 3 ? AppColors.primaryColor : Colors.black,
          //       ),
          //       title: const AppText(
          //         text: "Profile",
          //       ),
          //     ),
          //   ],
          // );
        },
      ),
    );
  }
}
