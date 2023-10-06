import 'dart:convert';

import 'package:bird_x/constants/app_colors.dart';
import 'package:bird_x/main.dart';
import 'package:bird_x/models/user_model.dart';
import 'package:bird_x/services/registration_services.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/utils/app_url_launch.dart';
import 'package:bird_x/utils/date_utils.dart';
import 'package:bird_x/views/main_page_views/menu_views/home_view.dart';
import 'package:bird_x/views/profile/about_us.dart';
import 'package:bird_x/views/profile/edit_profile.dart';
import 'package:bird_x/views/profile/my_pets.dart';
import 'package:bird_x/views/profile/privacy_policy.dart';
import 'package:bird_x/views/profile/update_password.dart';
import 'package:bird_x/views/registration_views/login.dart';
import 'package:bird_x/widgets/app_cached_image.dart';
import 'package:bird_x/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';

import '../../../constants/app_spacing.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  PackageInfo? packageInfo;
  LoginModel userData = LoginModel();
  @override
  void initState() {
    var data = jsonDecode(box.get("userData"));
    PackageInfo.fromPlatform().then((value) {
      setState(() {
        packageInfo = value;
      });
    });

    userData = LoginModel.fromJson(data);
    RegistrationServices.generateLink(userData.data!.referralCode.toString());
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
                  fit: BoxFit.cover,
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
                    AppSpacing.heigthSpace10,
                    AppText(
                      text: userData.data!.location!.address.toString(),
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                    AppSpacing.heigthSpace10,
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
                  img: "assets/icons/password_lock.svg",
                  text: "Update Password",
                  onTap: () {
                    AppNavigation.to(
                      context,
                      nextPage: UpdatePassword(
                        email: userData.data!.email.toString(),
                      ),
                    );
                  },
                ),
                ProfileTabWidget(
                  img: "assets/icons/share.svg",
                  text: "Tell your Friends",
                  onTap: () async {
                    Get.defaultDialog(
                      titlePadding: const EdgeInsets.only(
                        top: 10,
                        bottom: 5,
                      ),
                      title: "Refer your friends to PetX",
                      titleStyle: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.black),
                      content: const Center(
                        child: Column(
                          children: [
                            AppText(
                              text: "For every successful referral, we'll add an extra day to your listing's end date.",
                            ),
                            SizedBox(
                              height: 3,
                            ),
                            AppText(
                              text: "Share now and let your referrals bring extra life to your listings! 🐾🌟",
                            )
                          ],
                        ),
                      ),
                      textConfirm: "Share",
                      onCancel: () {
                        Get.back();
                      },
                      onConfirm: () async {
                        Get.back();
                        await Share.share(
                          inviteLink,
                        );
                      },
                      contentPadding: const EdgeInsets.only(
                        top: 0,
                        left: 25,
                        right: 25,
                        bottom: 25,
                      ),
                    );
                  },
                ),
                ProfileTabWidget(
                  img: "assets/icons/pets.svg",
                  text: "My Pets",
                  onTap: () {
                    AppNavigation.to(
                      context,
                      nextPage: const MyPets(),
                    );
                  },
                ),
                ProfileTabWidget(
                  img: "assets/icons/privacy.svg",
                  text: "Privacy Policy",
                  onTap: () {
                    AppNavigation.to(
                      context,
                      nextPage: const PrivacyPolicy(),
                    );
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
                  img: "assets/icons/support.svg",
                  text: "Contact Support",
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      showDragHandle: true,
                      backgroundColor: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      builder: (context) {
                        return Padding(
                          padding: AppSpacing.defaultPadding,
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      AppUrlLaunch.launchMyUrl("https://chat.whatsapp.com/C5mxlM4Cmh0LrZVBI13nzm");
                                    },
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "assets/images/community.png",
                                          height: 50,
                                          width: 50,
                                        ),
                                        AppSpacing.heigthSpace10,
                                        const AppText(
                                          text: "Join\nCommunity",
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      AppUrlLaunch.launchMyUrl("https://wa.me/+923081888686");
                                    },
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/whatsapp.svg",
                                          height: 50,
                                          width: 50,
                                        ),
                                        AppSpacing.heigthSpace10,
                                        const AppText(
                                          text: "Direct\nSupport",
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
                ProfileTabWidget(
                  img: "assets/icons/logout.svg",
                  text: "Logout",
                  onTap: () {
                    box.put("isLoggedIn", null);
                    box.deleteAt(0);
                    Get.deleteAll();

                    AppNavigation.offAll(
                      context,
                      nextPage: const Login(),
                    );
                  },
                ),
                AppSpacing.heigthSpace30,
                Align(
                  alignment: Alignment.bottomRight,
                  child: AppText(
                    text: packageInfo != null ? "v ${packageInfo!.version}" : "v 1.0.0",
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                )
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
                  // ignore: deprecated_member_use
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
