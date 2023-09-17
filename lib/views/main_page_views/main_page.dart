import 'package:bird_x/constants/app_colors.dart';
import 'package:bird_x/controllers/main_page_controllers/main_page_controller.dart';
import 'package:bird_x/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<MainPageController>(
        init: MainPageController(),
        builder: (controller) {
          return controller.allPages[controller.selectedIndex];
        },
      ),
      bottomNavigationBar: GetBuilder<MainPageController>(
          init: MainPageController(),
          builder: (_) {
            return SalomonBottomBar(
              currentIndex: _.selectedIndex,
              onTap: (value) {
                _.changeIndex(value);
              },
              items: [
                SalomonBottomBarItem(
                  icon: SvgPicture.asset(
                    "assets/icons/home.svg",
                    height: 30,
                    width: 30,
                    // ignore: deprecated_member_use
                    color: _.selectedIndex == 0 ? AppColors.primaryColor : Colors.black,
                  ),
                  title: const AppText(
                    text: "Home",
                  ),
                ),
                SalomonBottomBarItem(
                  icon: SvgPicture.asset(
                    "assets/icons/chats.svg",
                    height: 30,
                    width: 30,
                    // ignore: deprecated_member_use
                    color: _.selectedIndex == 1 ? AppColors.primaryColor : Colors.black,
                  ),
                  title: const AppText(
                    text: "Chats",
                  ),
                ),
                SalomonBottomBarItem(
                  icon: SvgPicture.asset(
                    "assets/icons/wishlist.svg",
                    height: 30,
                    width: 30,
                    // ignore: deprecated_member_use
                    color: _.selectedIndex == 2 ? AppColors.primaryColor : Colors.black,
                  ),
                  title: const AppText(
                    text: "WishList",
                  ),
                ),
                SalomonBottomBarItem(
                  icon: SvgPicture.asset(
                    "assets/icons/profile.svg",
                    height: 30,
                    width: 30,
                    // ignore: deprecated_member_use
                    color: _.selectedIndex == 3 ? AppColors.primaryColor : Colors.black,
                  ),
                  title: const AppText(
                    text: "Profile",
                  ),
                ),
              ],
            );
          }),
    );
  }
}
