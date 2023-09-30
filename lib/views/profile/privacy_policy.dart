import 'package:bird_x/constants/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/app_text.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        title: const AppText(
          text: "Privacy Policy",
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpacing.heigthSpace10,
              const AppText(
                text: "1. Introduction",
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              const AppText(
                text:
                    "\nWelcome to PetX! We are committed to protecting the privacy and security of your personal information. This Privacy Policy explains how we collect, use, share, and protect your data when you use our app.",
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey,
              ),
              const AppText(
                text: "\n2. Information We Collect\n",
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey,
                  ),
                  children: [
                    TextSpan(
                      text: " User Information: ",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const TextSpan(
                      text: " When you create an account, we collect information such as your name, email address, and profile picture.",
                    ),
                    TextSpan(
                      text: "\n\n Pet Listings: ",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const TextSpan(
                      text: " If you post pet, bird, or fish listings, we collect information about the animals you are listing, including descriptions, images, and asking prices.",
                    ),
                    TextSpan(
                      text: "\n\n Location Data: ",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const TextSpan(
                      text: " We may collect location data to provide you with location-based services and enhance your user experience.",
                    ),
                    TextSpan(
                      text: "\n\n Communication: ",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const TextSpan(
                      text: " We collect data related to your communications with other users through the app, including messages and reviews.",
                    ),
                  ],
                ),
              ),
              const AppText(
                text: "\n\n3. How We Use Your Information",
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              const AppText(
                text: "\nWe use the collected information for the following purposes:",
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey,
              ),
              const AppText(
                text: "\n => To facilitate the buying and selling of pets, birds, and fish.",
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey,
              ),
              const AppText(
                text: "\n => To personalize and improve your user experience.",
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey,
              ),
              const AppText(
                text: "\n => To communicate with you regarding your account, listings, and app updates.",
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey,
              ),
              const AppText(
                text: "\n => To ensure a safe and secure environment for all users.",
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey,
              ),
              const AppText(
                text: "\n\n4. Sharing Your Information",
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              const AppText(
                text: "\nWe may share your information with:",
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey,
              ),
              const AppText(
                text: "\n => Other users as necessary for the buying and selling process.",
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey,
              ),
              const AppText(
                text: "\n => Service providers who help us with app functionality and operations.",
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey,
              ),
              const AppText(
                text: "\n => Legal authorities when required by law or to protect our rights.",
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey,
              ),
              const AppText(
                text: "\n\n5. Data Security",
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              const AppText(
                text: "\nWe employ security measures to protect your data, but no method of transmission over the internet is completely secure. We cannot guarantee the security of your data.",
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey,
              ),
              const AppText(
                text: "\n\n6. Your Choices",
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              const AppText(
                text:
                    "\nYou can access, modify, or delete your personal information through your account settings. You may also contact us to exercise your rights under applicable data protection laws.",
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey,
              ),
              const AppText(
                text: "\n\n7. Children's Privacy",
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              const AppText(
                text: "\nOur app is not intended for children under the age of 13. We do not knowingly collect personal information from children.",
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey,
              ),
              const AppText(
                text: "\n\n8. Changes to this Privacy Policy",
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              const AppText(
                text: "\nWe may update this Privacy Policy to reflect changes in our practices or for other operational, legal, or regulatory reasons. We will notify you of any material changes.",
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.blueGrey,
              ),
              const AppText(
                text: "\n\n9. Contact Us",
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey,
                  ),
                  children: [
                    const TextSpan(
                      text: "\nIf you have any questions or concerns about our Privacy Policy or data practices, please contact us at ",
                    ),
                    TextSpan(
                      text: " petx.org@gmail.com\n\n",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              const Align(
                alignment: Alignment.bottomRight,
                child: AppText(
                  text: "Last Updated\n30 Sep 2023",
                  textAlign: TextAlign.center,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
