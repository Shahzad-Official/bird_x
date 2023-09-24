import 'dart:convert';

import 'package:bird_x/constants/app_colors.dart';
import 'package:bird_x/main.dart';
import 'package:bird_x/models/user_model.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/utils/date_utils.dart';
import 'package:bird_x/views/main_page_views/menu_views/home_view.dart';
import 'package:bird_x/views/profile/about_us.dart';
import 'package:bird_x/views/profile/edit_profile.dart';
import 'package:bird_x/views/profile/privacy_policy.dart';
import 'package:bird_x/widgets/app_cached_image.dart';
import 'package:bird_x/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';

import '../../../constants/app_spacing.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  LoginModel userData = LoginModel();
  @override
  void initState() {
    var data = jsonDecode(box.get("userData"));
    userData = LoginModel.fromJson(data);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: AppSpacing.defaultPadding,
            child: Column(
              children: [
                AppSpacing.heigthSpace20,
                AppCachedImage(
                  height: 150,
                  width: 150,
                  shape: BoxShape.circle,
                  url: userData.data!.profile.toString(),
                ),
                AppSpacing.heigthSpace10,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AppText(
                      text: "${userData.data!.firstName} ${userData.data!.lastName}",
                      color: AppColors.primaryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    AppText(
                      text: userData.data!.location!.address.toString(),
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                    AppText(
                      text: "Since ${AppDateUtils.formatDate(pattern: "dd MMM yyyy", date: userData.data!.createdOn.toString())}",
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
                ProfileTabWidget(
                  img: "assets/icons/edit.svg",
                  text: "Edit Profile",
                  onTap: () {
                    AppNavigation.to(context, nextPage: const EditProfile());
                  },
                ),
                ProfileTabWidget(
                  img: "assets/icons/sub.svg",
                  text: "Subscriptions",
                  onTap: () {},
                ),
                ProfileTabWidget(
                  img: "assets/icons/share.svg",
                  text: "Tell your Friends",
                  onTap: () {
                    Share.share("https://play.google.com/");
                  },
                ),
                ProfileTabWidget(
                  img: "assets/icons/pets.svg",
                  text: "My Pets",
                  onTap: () {
                    AppNavigation.to(context, nextPage: const HomeView());
                  },
                ),
                ProfileTabWidget(
                  img: "assets/icons/privacy.svg",
                  text: "Privacy Policy",
                  onTap: () {
                    AppNavigation.to(context, nextPage: const PrivacyPolicy());
                  },
                ),
                ProfileTabWidget(
                  img: "assets/icons/about.svg",
                  text: "About Us",
                  onTap: () {
                    AppNavigation.to(context, nextPage: const AboutUs());
                  },
                ),
                ProfileTabWidget(
                  img: "assets/icons/logout.svg",
                  text: "Logout",
                  onTap: () {},
                ),
                AppSpacing.heigthSpace30,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileTabWidget extends StatelessWidget {
  final String text;
  final String img;
  final void Function() onTap;

  const ProfileTabWidget({
    super.key,
    required this.text,
    required this.img,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: SizedBox(
            height: 45,
            width: double.infinity,
            child: Row(
              children: [
                const SizedBox(
                  width: 10,
                ),
                SvgPicture.asset(
                  img,
                  color: AppColors.primaryColor,
                  height: 27,
                  width: 27,
                ),
                const SizedBox(
                  width: 25,
                ),
                AppText(
                  text: text,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
            width: double.infinity,
            child: Divider(
              color: Colors.black,
              thickness: 0.1,
            )),
      ],
    );
  }
}
