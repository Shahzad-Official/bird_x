import 'dart:io';

import 'package:bird_x/constants/api_constant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_svg/svg.dart';

class AppCachedSvg extends StatefulWidget {
  final String url;
  final double? height, width;
  const AppCachedSvg({
    Key? key,
    required this.url,
    this.height = 30,
    this.width = 30,
  }) : super(key: key);

  @override
  State<AppCachedSvg> createState() => _AppCachedSvgState();
}

class _AppCachedSvgState extends State<AppCachedSvg> {
  String get url => "${ApiConstant.baseUrl}/${widget.url}";
  File? file;
  bool isLoading = false;
  getData() async {
    setState(() {
      isLoading = true;
    });
    DefaultCacheManager cacheManager = DefaultCacheManager();
    await cacheManager.getSingleFile(url).then((value) async {
      if (value.existsSync()) {
        file = value;
      } else {
        await cacheManager.downloadFile(url).then((value) {
          file = value.file;
        }).catchError((err) {
          debugPrint(err);
        });
      }
    }).catchError((err) {
      debugPrint(err);
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading || file == null) {
      return SizedBox(
        height: widget.height,
        width: widget.width,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return SvgPicture.file(
        file!,
        height: widget.height,
        width: widget.width,
      );
    }
  }
}
