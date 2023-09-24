import 'package:bird_x/constants/app_spacing.dart';
import 'package:flutter/material.dart';

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
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                children: [
                  AppText(
                    text: "Lorem",
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ],
              ),
              AppSpacing.heigthSpace10,
              AppText(
                text:
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus rhoncus, diam vitae semper lacinia, arcu turpis ornare nisi, non interdum ligula nunc nec ipsum. Donec suscipit in turpis eget pellentesque. Phasellus ornare at arcu at facilisis. Integer id augue id nisl varius semper sit amet sit amet sapien. Nulla laoreet, justo vel tempor ullamcorper, massa mauris volutpat tellus, posuere facilisis mauris sapien et magna. Integer sit amet dolor in quam eleifend condimentum. Cras imperdiet sem non metus eleifend, in tempus nisl mattis. Morbi eget tortor vitae arcu mollis dictum mattis non sapien. Praesent maximus risus mi, ut efficitur leo gravida eleifend. Nullam pharetra mauris quis leo tempor, non tincidunt ex fermentum. Pellentesque vitae nisi bibendum, egestas dui vitae, imperdiet dui. Nam vehicula augue non pharetra vulputate. In sed dapibus nunc, sed malesuada sapien. Nulla facilisi. Cras luctus tincidunt mauris, vitae rhoncus elit consequat vel. Phasellus fringilla, dui sed auctor bibendum, ante elit ultricies metus, vitae dapibus arcu justo ut nunc.  Cras luctus tincidunt mauris, vitae rhoncus elit consequat vel. Phasellus fringilla, dui sed auctor bibendum, ante elit ultricies metus, vitae dapibus arcu justo ut nunc.",
                fontWeight: FontWeight.w500,
                color: Color(0xff7F7F7F),
              )
            ],
          ),
        ),
      ),
    );
  }
}
