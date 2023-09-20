import 'package:bird_x/constants/app_colors.dart';
import 'package:bird_x/constants/app_spacing.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/widgets/app_text.dart';
import 'package:flutter/material.dart';

class Notifications extends StatelessWidget {
  const Notifications({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              AppNavigation.back(context);
            },
            child: const Icon(Icons.arrow_back_ios_new)),
        title: const AppText(
          text: "Notifications",
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: Padding(
        padding: AppSpacing.defaultPadding,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 78,
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF9140).withOpacity(0.1),
                    offset: const Offset(0, 4),
                    blurRadius: 15,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const AppText(
                          text: "29 June 2023, 7.14 PM",
                          color: Color(0xffBDBDBD),
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                        ),
                        Container(
                          height: 7,
                          width: 7,
                          decoration: const BoxDecoration(
                              color: AppColors.primaryColor,
                              shape: BoxShape.circle),
                        ),
                      ],
                    ),
                    const AppText(
                      text: "Payment Done Successfully.",
                      color: Color(0xff363853),
                      fontSize: 10,
                    ),
                    const AppText(
                      text: "Order#23",
                      color: Color(0xffBDBDBD),
                      fontSize: 12,
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
