import 'package:bird_x/constants/app_spacing.dart';
import 'package:bird_x/controllers/profile_controllers/edit_profile_controllers.dart';
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
    return GetBuilder<EditProfileController>(
      init: EditProfileController(),
      builder: (controller) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: ListView(
            shrinkWrap: true,
            children: [
              AppSpacing.heigthSpace20,
              const Center(
                  child: AppText(
                text: "Complete the registration data",
                fontSize: 16,
                fontWeight: FontWeight.w600,
              )),
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
                readOnly: true,
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
              GetBuilder<EditProfileController>(
                init: EditProfileController(),
                initState: (_) {},
                builder: (_) {
                  return AppButton(
                    text: "Google Login",
                    isLoading: _.isLoading,
                    onTap: () async {
                      await _.editUser(
                        context,
                        isUpdatePage: false,
                      );
                    },
                  );
                },
              )
            ],
          ),
        );
      },
    );
  }
}
