import 'package:bird_x/constants/app_spacing.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/widgets/app_button.dart';
import 'package:bird_x/widgets/app_text.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class Subscriptions extends StatefulWidget {
  const Subscriptions({super.key});

  @override
  State<Subscriptions> createState() => _SubscriptionsState();
}

class _SubscriptionsState extends State<Subscriptions> {
  final PageController _pageController = PageController();
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: AppSpacing.defaultPadding,
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (int index) {
                    setState(() {
                      currentPageIndex = index;
                    });
                  },
                  children: [
                    SubscriptionWidget(
                      ser1: "+ Service1",
                      ser2: "+ Service2",
                      ser3: "+ Service3",
                      ser4: "+ Service4",
                      img: "assets/images/onboard3.png",
                      text: 'Monthly',
                      price: "999\$",
                      onTap: () {},
                    ),
                    SubscriptionWidget(
                      ser1: "+ Service1",
                      ser2: "+ Service2",
                      ser3: "+ Service3",
                      ser4: "+ Service4",
                      img: "assets/images/onboard3.png",
                      text: 'Monthly',
                      price: "1000\$",
                      onTap: () {},
                    ),
                    SubscriptionWidget(
                      ser1: "+ Service1",
                      ser2: "+ Service2",
                      ser3: "+ Service3",
                      ser4: "+ Service4",
                      img: "assets/images/onboard3.png",
                      text: 'Monthly',
                      price: "1111\$",
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      AppNavigation.back(context);
                    },
                    child: const AppText(
                      text: "Back",
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  DotsIndicator(
                    dotsCount: 3,
                    position: currentPageIndex,
                    decorator: DotsDecorator(
                      size: const Size.square(10.0),
                      activeSize: const Size(20.0, 10.0),
                      activeShape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  GestureDetector(
                      onTap: () {
                        if (currentPageIndex < 2) {
                          currentPageIndex++;
                          _pageController.animateToPage(
                            currentPageIndex,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      child: const AppText(
                        text: "Next",
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      )),
                ],
              ),
              AppSpacing.heigthSpace30,
            ],
          ),
        ),
      ),
    );
  }
}

class SubscriptionWidget extends StatelessWidget {
  final void Function()? onTap;
  final String? ser1, ser2, ser3, ser4;
  final String img, text, price;
  const SubscriptionWidget(
      {super.key,
      this.ser1,
      this.onTap,
      this.ser2,
      this.ser3,
      this.ser4,
      required this.img,
      required this.text,
      required this.price});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.defaultPadding,
      child: Column(
        children: [
          Image.asset(img),
          AppSpacing.heigthSpace30,
          AppText(
            text: text,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          AppSpacing.heigthSpace5,
          AppText(
            text: price,
            color: Colors.blueGrey,
            fontSize: 28,
            fontWeight: FontWeight.w700,
          ),
          AppSpacing.heigthSpace10,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AppText(
                text: ser1.toString(),
                fontSize: 20,
              ),
              AppText(
                text: ser2.toString(),
                fontSize: 20,
              ),
            ],
          ),
          AppSpacing.heigthSpace10,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AppText(
                text: ser3.toString(),
                fontSize: 20,
              ),
              AppText(
                text: ser4.toString(),
                fontSize: 20,
              ),
            ],
          ),
          AppSpacing.heigthSpace30,
          AppSpacing.heigthSpace20,
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            child: AppButton(
              text: "Buy Now",
              onTap: onTap,
            ),
          )
        ],
      ),
    );
  }
}
