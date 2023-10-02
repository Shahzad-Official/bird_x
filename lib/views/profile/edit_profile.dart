import 'dart:convert';

import 'package:bird_x/constants/app_colors.dart';
import 'package:bird_x/main.dart';
import 'package:bird_x/models/user_model.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/widgets/app_field.dart';
import 'package:bird_x/widgets/app_shadowcontainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/app_spacing.dart';
import '../../controllers/profile_controllers/edit_profile_controllers.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final EditProfileController _controller = Get.put(EditProfileController());
  LoginModel userData = LoginModel();

  @override
  void initState() {
    var data = jsonDecode(box.get("userData"));
    userData = LoginModel.fromJson(data);
    _controller.initializeData(userData);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(text: "Update Profile"),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.defaultPadding,
          child: ListView(
            shrinkWrap: true,
            children: [
              AppSpacing.heigthSpace30,
              Center(
                child: SizedBox(
                  height: 150,
                  width: 150,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      GetBuilder<EditProfileController>(
                        init: EditProfileController(),
                        initState: (_) {},
                        builder: (_) {
                          return AppShadowcontainer(
                            height: 150,
                            width: 150,
                            image: _.profile == null
                                ? const AssetImage(
                                    "assets/images/placeholder.png",
                                  )
                                : FileImage(_.profile!) as ImageProvider,
                            child: const SizedBox(),
                          );
                        },
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateColor.resolveWith(
                              (states) => AppColors.primaryColor,
                            ),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              backgroundColor: Colors.white,
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          AppNavigation.back(context);
                                          _controller.pickProfile(source: ImageSource.camera);
                                        },
                                        child: const SizedBox(
                                          height: 120,
                                          child: Column(
                                            children: [
                                              AppShadowcontainer(
                                                child: Icon(
                                                  Icons.camera_alt_outlined,
                                                ),
                                              ),
                                              AppSpacing.heigthSpace10,
                                              AppText(
                                                text: "Camera",
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              AppSpacing.heigthSpace10,
                                            ],
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          AppNavigation.back(context);
                                          _controller.pickProfile(source: ImageSource.gallery);
                                        },
                                        child: const SizedBox(
                                          height: 120,
                                          child: Column(
                                            children: [
                                              AppShadowcontainer(
                                                child: Icon(
                                                  Icons.photo_outlined,
                                                ),
                                              ),
                                              AppSpacing.heigthSpace10,
                                              AppText(
                                                text: "Gallery",
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              AppSpacing.heigthSpace10,
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.camera,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AppSpacing.heigthSpace20,
              AppSpacing.heigthSpace30,
              Row(
                children: [
                  Expanded(
                    child: AppField(
                      controller: _controller.firstName,
                      hintText: "First Name",
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: AppField(
                      controller: _controller.lastName,
                      hintText: "Last Name",
                    ),
                  ),
                ],
              ),
              AppSpacing.heigthSpace20,
              AppField(
                readOnly: true,
                controller: _controller.email,
                hintText: "Email",
                textType: TextInputType.emailAddress,
                prefixIcon: const Icon(
                  Icons.email_outlined,
                  color: AppColors.primaryColor,
                ),
              ),
              AppSpacing.heigthSpace20,
              AppPhoneField(
                controller: _controller.number,
                initialCountry: box.get("myCountryCode"),
                onChanged: (number) {
                  _controller.countryCode = number.countryCode;
                },
              ),
              AppSpacing.heigthSpace20,
              const AppText(
                text: "Select Gender:",
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
              GetBuilder<EditProfileController>(
                init: EditProfileController(),
                initState: (_) {},
                builder: (_) {
                  return RadioListTile(
                    value: "Male",
                    groupValue: _.groupValue,
                    onChanged: (value) {
                      _.changeGender(value.toString());
                    },
                    title: const AppText(
                      text: "Male",
                    ),
                  );
                },
              ),
              GetBuilder<EditProfileController>(
                init: EditProfileController(),
                initState: (_) {},
                builder: (_) {
                  return RadioListTile(
                    value: "Female",
                    groupValue: _.groupValue,
                    onChanged: (value) {
                      _.changeGender(value.toString());
                    },
                    title: const AppText(
                      text: "Female",
                    ),
                  );
                },
              ),
              GetBuilder<EditProfileController>(
                init: EditProfileController(),
                initState: (_) {},
                builder: (_) {
                  return RadioListTile(
                    value: "Other",
                    groupValue: _.groupValue,
                    onChanged: (value) {
                      _.changeGender(value.toString());
                    },
                    title: const AppText(
                      text: "Other",
                    ),
                  );
                },
              ),
              AppSpacing.heigthSpace20,
              AppField(
                readOnly: true,
                controller: _controller.location,
                onTap: () async {
                  await _controller.pickLocation(context);
                },
                suffixIcon: const Icon(
                  Icons.location_on_outlined,
                ),
              ),
              AppSpacing.heigthSpace30,
              GetBuilder<EditProfileController>(
                init: EditProfileController(),
                initState: (_) {},
                builder: (_) {
                  return AppButton(
                    isLoading: _.isLoading,
                    onTap: () async {
                      await _.editUser(context);
                    },
                    text: "Update Profile",
                  );
                },
              ),
              AppSpacing.heigthSpace30,
            ],
          ),
        ),
      ),
    );
  }
}
