import 'package:bird_x/constants/app_spacing.dart';
import 'package:bird_x/widgets/app_logo.dart';
import 'package:flutter/material.dart';

import '../../widgets/app_field.dart';

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.defaultPadding,
          child: Column(
            children: [
              AppLogo(),
              AppSpacing.heigthSpace20,
              AppField(),
            ],
          ),
        ),
      ),
    );
  }
}
