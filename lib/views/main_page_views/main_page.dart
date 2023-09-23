import 'package:bird_x/constants/app_colors.dart';
import 'package:bird_x/controllers/main_page_controllers/main_page_controller.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/views/add_product/add_product.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late PageController _pageController;
  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0,
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
                  color: _.selectedIndex == 0
                      ? AppColors.primaryColor
                      : Colors.black,
                ),
                label: "Home",
              ),
              NavigationDestination(
                icon: SvgPicture.asset(
                  "assets/icons/chats.svg",
                  height: 30,
                  width: 30,
                  // ignore: deprecated_member_use
                  color: _.selectedIndex == 1
                      ? AppColors.primaryColor
                      : Colors.black,
                ),
                label: "Chats",
              ),
              NavigationDestination(
                icon: SvgPicture.asset(
                  "assets/icons/wishlist.svg",
                  height: 30,
                  width: 30,
                  // ignore: deprecated_member_use
                  color: _.selectedIndex == 2
                      ? AppColors.primaryColor
                      : Colors.black,
                ),
                label: "WishList",
              ),
              NavigationDestination(
                icon: SvgPicture.asset(
                  "assets/icons/profile.svg",
                  height: 30,
                  width: 30,
                  // ignore: deprecated_member_use
                  color: _.selectedIndex == 3
                      ? AppColors.primaryColor
                      : Colors.black,
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
