import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppLogo extends StatelessWidget {
  final bool isShadowLogo;
  const AppLogo({
    Key? key,
    this.isShadowLogo = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: isShadowLogo ? 120 : 150,
      width: isShadowLogo ? 120 : 150,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: isShadowLogo
            ? [
                BoxShadow(
                  color: const Color(0xFFDED8D5).withOpacity(0.2),
                  blurRadius: 6,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
                BoxShadow(
                  color: const Color(0xFFDED8D5).withOpacity(0.5),
                  blurRadius: 14,
                  spreadRadius: 4,
                  offset: const Offset(0, 7),
                ),
              ]
            : null,
      ),
      child: Center(
        child: SvgPicture.asset(
          "assets/icons/logo.svg",
          height: isShadowLogo ? 65 : null,
          width: isShadowLogo ? 65 : null,
        ),
      ),
    );
  }
}
