import 'package:bird_x/constants/app_colors.dart';
import 'package:bird_x/constants/app_spacing.dart';
import 'package:bird_x/controllers/registration_controllers/reset_password_controller.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/views/registration_views/successfull_registration.dart';
import 'package:bird_x/widgets/app_button.dart';
import 'package:bird_x/widgets/app_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ResetPassword extends StatelessWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: AppSpacing.defaultPadding,
        child: ListView(
          shrinkWrap: true,
          children: [
            SvgPicture.asset(
              "assets/icons/reset_pass.svg",
              height: MediaQuery.of(context).size.height * 0.4,
            ),
            AppSpacing.heigthSpace30,
            GetBuilder<ResetPasswordController>(
              init: ResetPasswordController(),
              initState: (_) {},
              builder: (_) {
                return AppField(
                  isObsecure: _.isObsecure,
                  textType: TextInputType.visiblePassword,
                  hintText: "Password",
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
                );
              },
            ),
            AppSpacing.heigthSpace30,
            GetBuilder<ResetPasswordController>(
              init: ResetPasswordController(),
              initState: (_) {},
              builder: (_) {
                return AppField(
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
                );
              },
            ),
            AppSpacing.heigthSpace30,
            AppButton(
              onTap: () {
                AppNavigation.offAll(
                  context,
                  nextPage: const SuccessfullRegistration(
                    isForgetPass: true,
                  ),
                );
              },
              text: "RESET PASSWORD",
            ),
          ],
        ),
      ),
    );
  }
}
