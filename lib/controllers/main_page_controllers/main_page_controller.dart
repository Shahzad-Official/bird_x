import 'package:bird_x/main.dart';
import 'package:bird_x/views/main_page_views/menu_views/chats_view.dart';
import 'package:bird_x/views/main_page_views/menu_views/home_view.dart';
import 'package:bird_x/views/main_page_views/menu_views/profile_view.dart';
import 'package:bird_x/views/main_page_views/menu_views/wishlist_view.dart';
import 'package:bird_x/views/registration_views/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainPageController extends GetxController {
  int selectedIndex = 0;
  changeIndex(int index) {
    selectedIndex = index;
    update();
  }

  Widget get currentPage => allPages[selectedIndex];

  List<Widget> allPages = [
    const HomeView(),
    box.get("isGuest")
        ? const Login(
            isGuest: true,
          )
        : const ChatsView(),
    const WishlistView(),
    box.get("isGuest")
        ? const Login(
            isGuest: true,
          )
        : const ProfileView(),
  ];
}
