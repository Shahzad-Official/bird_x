import 'package:bird_x/constants/app_colors.dart';
import 'package:bird_x/constants/app_spacing.dart';
import 'package:bird_x/controllers/registration_controllers/otp_controller.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/views/registration_views/reset_password.dart';
import 'package:bird_x/views/registration_views/successfull_registration.dart';
import 'package:bird_x/widgets/app_button.dart';
import 'package:bird_x/widgets/app_logo.dart';
import 'package:bird_x/widgets/app_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

class OtpVerification extends StatefulWidget {
  final String email;
  final bool isForgetEmail;
  const OtpVerification({
    Key? key,
    required this.email,
    this.isForgetEmail = false,
  }) : super(key: key);

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final OtpController _controller = Get.put(OtpController());
  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
    decoration: BoxDecoration(
      border: Border.all(color: AppColors.primaryColor),
      borderRadius: BorderRadius.circular(20),
    ),
  );

  get focusedPinTheme => defaultPinTheme.copyDecorationWith(
        border: Border.all(
          color: AppColors.primaryColor,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      );

  get submittedPinTheme => defaultPinTheme.copyWith(
        decoration: defaultPinTheme.decoration!.copyWith(
          color: const Color.fromARGB(255, 253, 219, 195).withOpacity(0.2),
        ),
      );

  @override
  void initState() {
    _controller.startTimer();
    super.initState();
  }

  @override
  void dispose() {
    _controller.disposeTimer();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: "OTP Verification",
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.defaultPadding,
          child: ListView(
            shrinkWrap: true,
            children: [
              SizedBox(
                height: size.height * 0.1,
              ),
              const AppLogo(),
              AppSpacing.heigthSpace30,
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "A Verification Code has been sent to your email check your email:",
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    TextSpan(
                      text: " ${widget.email}",
                      style: GoogleFonts.poppins(
                        fontSize: 17,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              AppSpacing.heigthSpace30,
              AppSpacing.heigthSpace30,
              GetBuilder<OtpController>(
                init: OtpController(),
                initState: (_) {},
                builder: (_) {
                  return RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: _.isOtpExpires ? "" : "Resend Code in: ",
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        TextSpan(
                          text: _.isOtpExpires ? "Resend Code" : "${_.otpTime}",
                          style: GoogleFonts.poppins(
                            fontSize: 17,
                            color: _.isOtpExpires ? AppColors.primaryColor : Colors.black,
                            fontWeight: FontWeight.w600,
                            decoration: _.isOtpExpires ? TextDecoration.underline : null,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              if (_.isOtpExpires) {
                                _controller.startTimer();
                              }
                            },
                        ),
                      ],
                    ),
                  );
                },
              ),
              AppSpacing.heigthSpace30,
              Pinput(
                length: 5,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
              ),
              AppSpacing.heigthSpace30,
              AppButton(
                onTap: () {
                  if (widget.isForgetEmail) {
                    AppNavigation.offAll(
                      context,
                      nextPage: const ResetPassword(),
                    );
                  } else {
                    AppNavigation.offAll(
                      context,
                      nextPage: const SuccessfullRegistration(
                        isForgetPass: false,
                      ),
                    );
                  }
                },
                text: "VERIFY",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
