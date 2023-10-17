import 'package:bird_x/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';

class AppField extends StatefulWidget {
  final TextEditingController? controller;
  final Widget? prefixIcon, suffixIcon;
  final String? hintText, labelText;
  final TextInputType? textType;
  final bool isObsecure, readOnly;
  final void Function()? onTap;
  final int maxLines;
  final bool isRequired;
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
    this.isRequired = false,
  });

  @override
  State<AppField> createState() => _AppFieldState();
}

class _AppFieldState extends State<AppField> {
  String? label;
  bool isFocus = false;
  changeFocus(bool value) {
    setState(() {
      isFocus = value;
    });
  }

  @override
  void initState() {
    setState(() {
      label = widget.labelText ?? widget.hintText;
    });

    super.initState();
  }

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
      child: Focus(
        onFocusChange: (value) {
          changeFocus(value);
        },
        child: TextFormField(
          maxLines: widget.maxLines,
          onTap: widget.onTap,
          readOnly: widget.readOnly,
          obscureText: widget.isObsecure,
          keyboardType: widget.textType,
          controller: widget.controller,
          decoration: InputDecoration(
            alignLabelWithHint: true,
            labelText: widget.isRequired && isFocus ? "$label *" : label,
            labelStyle: GoogleFonts.poppins(),
            hintText: widget.hintText,
            hintStyle: GoogleFonts.poppins(),
            contentPadding: const EdgeInsets.all(10),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
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
  final void Function(String value)? onChanged;
  const SearchField({
    super.key,
    this.controller,
    this.prefixIcon,
    this.suffixIcon,
    this.hintText,
    this.textType,
    this.onTap,
    this.onSubmit,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onFieldSubmitted: onSubmit,
      onTap: onTap,
      onChanged: onChanged,
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
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
    );
  }
}
