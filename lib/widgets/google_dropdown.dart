import 'package:bird_x/constants/app_spacing.dart';
import 'package:bird_x/controllers/registration_controllers/login_controller.dart';
import 'package:bird_x/main.dart';
import 'package:bird_x/widgets/app_button.dart';
import 'package:bird_x/widgets/app_field.dart';
import 'package:bird_x/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

class GoogleDropdown extends StatelessWidget {
  const GoogleDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
        init: LoginController(),
        builder: (controller) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppSpacing.heigthSpace20,
                const AppText(text: "Fill data to proceed"),
                AppSpacing.heigthSpace20,
                AppPhoneField(
                  controller: controller.number,
                  initialCountry: box.get("myCountryCode"),
                  onChanged: (number) {
                    controller.countryCode = number.countryCode;
                  },
                ),
                AppSpacing.heigthSpace20,
                AppField(
                  controller: controller.location,
                  onTap: () async {
                    await controller.pickLocation(context);
                  },
                  suffixIcon: const Icon(
                    Icons.location_on_outlined,
                  ),
                ),
                AppSpacing.heigthSpace20,
                const AppText(text: "Select Gender"),
                Row(
                  children: [
                    Radio(
                      value: "Male",
                      groupValue: controller.groupValue,
                      onChanged: (value) {
                        controller.changeGender(value.toString());
                      },
                    ),
                    const AppText(text: "Male"),
                    Radio(
                      value: "Female",
                      groupValue: controller.groupValue,
                      onChanged: (value) {
                        controller.changeGender(value.toString());
                      },
                    ),
                    const AppText(text: "Female"),
                    Radio(
                      value: "Other",
                      groupValue: controller.groupValue,
                      onChanged: (value) {
                        controller.changeGender(value.toString());
                      },
                    ),
                    const AppText(text: "Other"),
                  ],
                ),
                AppSpacing.heigthSpace30,
                AppButton(
                  text: "Google Login",
                  onTap: () async {
                    await controller.googleLogin(context,);
                  },
                )
              ],
            ),
          );
        });
  }
}
