import 'package:bird_x/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class AppField extends StatelessWidget {
  final TextEditingController? controller;
  final Widget? prefixIcon, suffixIcon;
  final String? hintText;
  final TextInputType? textType;
  final bool isObsecure;
  final void Function()? onTap;
  const AppField({
    super.key,
    this.controller,
    this.prefixIcon,
    this.hintText,
    this.textType,
    this.suffixIcon,
    this.isObsecure = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
          primary: AppColors.primaryColor,
          secondary: AppColors.primaryColor,
        ),
      ),
      child: TextFormField(
        onTap: onTap,
        readOnly: onTap == null ? false : true,
        obscureText: isObsecure,
        keyboardType: textType,
        controller: controller,
        decoration: InputDecoration(
          labelText: hintText,
          labelStyle: GoogleFonts.poppins(),
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(),
          contentPadding: const EdgeInsets.all(10),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.primaryColor,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.primaryColor,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class AppPhoneField extends StatelessWidget {
  final String? initialCountry;
  final TextEditingController? controller;
  final String? hintText;
  final void Function(PhoneNumber number)? onChanged;
  const AppPhoneField({
    Key? key,
    this.initialCountry,
    this.controller,
    this.hintText,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
          primary: AppColors.primaryColor,
          secondary: AppColors.primaryColor,
        ),
      ),
      child: IntlPhoneField(
        initialCountryCode: initialCountry,
        onChanged: onChanged,
        decoration: InputDecoration(
          counterText: "",
          labelText: hintText,
          labelStyle: GoogleFonts.poppins(),
          hintText: hintText,
          hintStyle: GoogleFonts.poppins(),
          contentPadding: const EdgeInsets.all(10),
          border: InputBorder.none,
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.primaryColor,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.primaryColor,
              width: 2,
            ),
          ),
          errorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),
          focusedErrorBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
