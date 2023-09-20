import 'package:flutter/material.dart';

class AppShadowcontainer extends StatelessWidget {
  final double? height, width;
  final Color? color;
  final Widget child;
  final BoxShape? shape;
  final ImageProvider? image;
  const AppShadowcontainer({
    Key? key,
    this.height,
    this.width,
    this.color,
    required this.child,
    this.shape,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 70,
      width: width ?? 70,
      decoration: BoxDecoration(
        borderRadius: shape == null ? null : BorderRadius.circular(10),
        color: color ?? Colors.white,
        shape: shape ?? BoxShape.circle,
        boxShadow: [
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
        ],
        image: image == null
            ? null
            : DecorationImage(
                image: image!,
                fit: BoxFit.cover,
              ),
      ),
      child: Center(
        child: child,
      ),
    );
  }
}
