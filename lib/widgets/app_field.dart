import 'package:bird_x/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class AppField extends StatelessWidget {
  final TextEditingController? controller;
  final Widget? prefixIcon, suffixIcon;
  final String? hintText, labelText;
  final TextInputType? textType;
  final bool isObsecure, readOnly;
  final void Function()? onTap;
  final int maxLines;
  const AppField({
    super.key,
    this.controller,
    this.prefixIcon,
    this.hintText,
    this.textType,
    this.suffixIcon,
    this.isObsecure = false,
    this.onTap,
    this.labelText,
    this.readOnly = false,
    this.maxLines = 1,
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
        maxLines: maxLines,
        onTap: onTap,
        readOnly: readOnly,
        obscureText: isObsecure,
        keyboardType: textType,
        controller: controller,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          labelText: labelText ?? hintText,
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
        controller: controller,
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

class SearchField extends StatelessWidget {
  final TextEditingController? controller;
  final Widget? prefixIcon, suffixIcon;
  final String? hintText;
  final TextInputType? textType;
  final void Function()? onTap;
  final void Function(String value)? onSubmit;
  const SearchField({
    super.key,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.textType,
    this.onTap,
    this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, 4),
            blurRadius: 4,
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextFormField(
        onFieldSubmitted: onSubmit,
        onTap: onTap,
        readOnly: onTap == null ? false : true,
        keyboardType: textType,
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelStyle: GoogleFonts.poppins(),
          hintText: hintText,
          hintStyle: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: const Color(0xffABAAAA),
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black.withOpacity(0.1), width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black.withOpacity(0.1), width: 1),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
