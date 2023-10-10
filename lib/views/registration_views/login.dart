import 'package:bird_x/constants/app_colors.dart';
import 'package:bird_x/constants/app_spacing.dart';
import 'package:bird_x/controllers/registration_controllers/login_controller.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/views/registration_views/forget_password.dart';
import 'package:bird_x/views/registration_views/signup.dart';
import 'package:bird_x/widgets/app_button.dart';
import 'package:bird_x/widgets/app_logo.dart';
import 'package:bird_x/widgets/app_shadowcontainer.dart';
import 'package:bird_x/widgets/app_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/app_field.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final LoginController _controller = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.defaultPadding,
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                height: size.height * 0.05,
              ),
              Row(
                children: [
                  const AppText(
                    text: "Welcome To PetX ",
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                  ),
                  SvgPicture.asset(
                    "assets/icons/login.svg",
                    // ignore: deprecated_member_use
                    color: AppColors.primaryColor,
                    height: 35,
                    width: 35,
                  ),
                ],
              ),
              AppSpacing.heigthSpace20,
              const AppLogo(),
              AppSpacing.heigthSpace30,
              AppField(
                controller: _controller.email,
                hintText: "Email",
                textType: TextInputType.emailAddress,
                prefixIcon: const Icon(
                  Icons.email_outlined,
                ),
              ),
              AppSpacing.heigthSpace20,
              GetBuilder<LoginController>(
                init: LoginController(),
                initState: (_) {},
                builder: (_) {
                  return AppField(
                    controller: _.password,
                    isObsecure: _.isObsecure,
                    textType: TextInputType.visiblePassword,
                    hintText: "Password",
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        _.changeObsecurity();
                      },
                      icon: Icon(
                        _.isObsecure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      ),
                    ),
                  );
                },
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    AppNavigation.offAll(
                      context,
                      nextPage: const ForgetPassword(),
                    );
                  },
                  child: const AppText(
                    text: "Forget Password?",
                  ),
                ),
              ),
              AppSpacing.heigthSpace30,
              GetBuilder<LoginController>(
                init: LoginController(),
                initState: (_) {},
                builder: (_) {
                  return AppButton(
                    isLoading: _.isLoading,
                    onTap: () async {
                      await _.login(context);
                    },
                    text: "LOGIN",
                  );
                },
              ),
              AppSpacing.heigthSpace30,
              const Row(
                children: [
                  Expanded(
                    child: Divider(),
                  ),
                  AppText(
                    text: "  OR  ",
                    color: Colors.grey,
                  ),
                  Expanded(
                    child: Divider(),
                  ),
                ],
              ),
              AppSpacing.heigthSpace20,
              Center(
                child: Wrap(
                  spacing: 30,
                  runSpacing: 50,
                  children: [
                    GetBuilder<LoginController>(
                      init: LoginController(),
                      initState: (_) {},
                      builder: (_) {
                        return InkWell(
                          onTap: () async {
                            await _.googleLogin(context);
                          },
                          child: AppShadowcontainer(
                            height: 55,
                            width: 190,
                            shape: BoxShape.rectangle,
                            child: _.googleLoading
                                ? const SpinKitChasingDots(
                                    color: AppColors.primaryColor,
                                    size: 20,
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/google.svg",
                                        height: 30,
                                        width: 30,
                                      ),
                                      const AppText(
                                        text: "Google Login",
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ],
                                  ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              AppSpacing.heigthSpace30,
              Center(
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "Don't have an account? ",
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          color: Colors.black,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      TextSpan(
                        text: "SignUp",
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            AppNavigation.offAll(
                              context,
                              nextPage: const Signup(),
                            );
                          },
                        style: GoogleFonts.poppins(
                          fontSize: 17,
                          color: AppColors.primaryColor,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
