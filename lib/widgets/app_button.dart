import 'package:bird_x/constants/app_colors.dart';
import 'package:bird_x/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isLoading;
  final double? height;
  const AppButton({
    Key? key,
    required this.text,
    this.onTap,
    this.isLoading = false,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: height,
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.primaryColor,
        ),
        child: Center(
          child: isLoading
              ? const SpinKitChasingDots(
                  color: Colors.white,
                  size: 25,
                )
              : AppText(
                  text: text,
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
        ),
      ),
    );
  }
}
