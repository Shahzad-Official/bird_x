import 'package:bird_x/constants/api_constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class AppCachedImage extends StatelessWidget {
  final String url;
  final double? height, width;
  final BorderRadiusGeometry? borderRadius;
  final BoxShape shape;
  final Widget? child;
  final Color? color;
  final BoxFit? fit;
  const AppCachedImage({
    Key? key,
    required this.url,
    this.borderRadius,
    this.height,
    this.shape = BoxShape.rectangle,
    this.width,
    this.child,
    this.color,
    this.fit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: CachedNetworkImage(
        imageUrl: "${ApiConstant.baseUrl}/$url",
        imageBuilder: (context, imageProvider) {
          return Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: color,
              borderRadius: borderRadius,
              shape: shape,
              image: DecorationImage(
                image: imageProvider,
                fit: fit,
              ),
            ),
            child: child,
          );
        },
        progressIndicatorBuilder: (context, url, progress) {
          return Center(
            child: CircularProgressIndicator(
              value: progress.progress,
            ),
          );
        },
        errorWidget: (context, url, error) {
          return Container(
            height: height,
            width: width,
            decoration: BoxDecoration(
              color: color,
              borderRadius: borderRadius,
              shape: shape,
              image: DecorationImage(
                image: const AssetImage("assets/images/placeholder.png"),
                fit: fit,
              ),
            ),
            child: child,
          );
        },
      ),
    );
  }
}
