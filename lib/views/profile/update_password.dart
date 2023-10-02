import 'package:bird_x/constants/app_colors.dart';
import 'package:bird_x/constants/app_spacing.dart';
import 'package:bird_x/controllers/profile_controllers/edit_profile_controllers.dart';
import 'package:bird_x/widgets/app_button.dart';
import 'package:bird_x/widgets/app_field.dart';
import 'package:bird_x/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class UpdatePassword extends StatelessWidget {
  final String email;
  const UpdatePassword({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(text: "Update Password"),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.defaultPadding,
          child: GetBuilder<EditProfileController>(
              init: EditProfileController(),
              builder: (_) {
                return Center(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      SvgPicture.asset(
                        "assets/icons/reset_password.svg",
                        height: 250,
                      ),
                      AppSpacing.heigthSpace20,
                      AppField(
                        controller: _.oldPassword,
                        isObsecure: _.isObsecureOld,
                        textType: TextInputType.visiblePassword,
                        hintText: "Old Password",
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: AppColors.primaryColor,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            _.changeObsecurityOld();
                          },
                          icon: Icon(
                            _.isObsecureOld ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      AppSpacing.heigthSpace30,
                      AppField(
                        controller: _.password,
                        isObsecure: _.isObsecure,
                        textType: TextInputType.visiblePassword,
                        hintText: "New Password",
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: AppColors.primaryColor,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            _.changeObsecurity();
                          },
                          icon: Icon(
                            _.isObsecure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      AppSpacing.heigthSpace30,
                      AppField(
                        controller: _.cpassword,
                        isObsecure: _.isObsecure1,
                        textType: TextInputType.visiblePassword,
                        hintText: "Confirm Password",
                        prefixIcon: const Icon(
                          Icons.lock_outline,
                          color: AppColors.primaryColor,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            _.changeObsecurity1();
                          },
                          icon: Icon(
                            _.isObsecure1 ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          ),
                        ),
                      ),
                      AppSpacing.heigthSpace30,
                      AppButton(
                        isLoading: _.isLoading,
                        onTap: () async {
                          await _.updatePassword(context, email: email);
                        },
                        text: "Update Password",
                      ),
                      AppSpacing.heigthSpace30,
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
