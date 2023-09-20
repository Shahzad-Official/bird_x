import 'package:bird_x/constants/app_colors.dart';
import 'package:bird_x/constants/app_spacing.dart';
import 'package:bird_x/controllers/registration_controllers/reset_password_controller.dart';
import 'package:bird_x/widgets/app_button.dart';
import 'package:bird_x/widgets/app_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ResetPassword extends StatefulWidget {
  final String email;
  const ResetPassword({Key? key, required this.email}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final ResetPasswordController _controller = Get.put(ResetPasswordController());
  @override
  void initState() {
    _controller.email = widget.email;
    super.initState();
  }

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
                  controller: _.password,
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
                );
              },
            ),
            AppSpacing.heigthSpace30,
            GetBuilder<ResetPasswordController>(
              init: ResetPasswordController(),
              initState: (_) {},
              builder: (_) {
                return AppButton(
                  isLoading: _.isLoading,
                  onTap: () async {
                    await _.resetPass(context);
                  },
                  text: "RESET PASSWORD",
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
