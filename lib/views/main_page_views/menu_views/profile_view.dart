import 'package:bird_x/constants/app_colors.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/views/main_page_views/menu_views/home_view.dart';
import 'package:bird_x/views/profile/about_us.dart';
import 'package:bird_x/views/profile/edit_profile.dart';
import 'package:bird_x/views/profile/privacy_policy.dart';
import 'package:bird_x/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:share_plus/share_plus.dart';

import '../../../constants/app_spacing.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: AppSpacing.defaultPadding,
            child: Column(
              children: [
                AppSpacing.heigthSpace10,
                Row(
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(
                                "https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80",
                              ),
                              fit: BoxFit.cover)),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.50,
                          child: const Flexible(
                            child: AppText(
                              text: "MR. ABC",
                              color: AppColors.primaryColor,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              overFlow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const AppText(
                          text: "Multan",
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        const AppText(
                          text: "Since 2022",
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ],
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
