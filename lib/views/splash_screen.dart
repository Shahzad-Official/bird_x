import 'dart:convert';
import 'dart:io';

import 'package:bird_x/constants/app_colors.dart';
import 'package:bird_x/constants/app_spacing.dart';
import 'package:bird_x/main.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/views/registration_views/login.dart';
import 'package:bird_x/widgets/app_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    try {
      http.get(Uri.parse('http://ip-api.com/json')).then((value) {
        box.put("myCountryCode", json.decode(value.body)['countryCode']);
      });
    } on SocketException catch (err) {
      debugPrint(err.message);
    }
    Future.delayed(
      const Duration(seconds: 3),
      () {
        AppNavigation.offAll(
          context,
          nextPage: const Login(),
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(50),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xffFAF9FE).withOpacity(0.21),
                    const Color(0xffFAF9FE).withOpacity(0),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: const AppLogo(
                isShadowLogo: false,
              ),
            ),
            AppSpacing.heigthSpace30,
            const SpinKitSpinningLines(
              lineWidth: 4,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
