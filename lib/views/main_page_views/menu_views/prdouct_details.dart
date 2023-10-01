import 'package:bird_x/constants/app_colors.dart';
import 'package:bird_x/constants/app_spacing.dart';
import 'package:bird_x/models/all_product_model.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/widgets/app_button.dart';
import 'package:bird_x/widgets/app_text.dart';
import 'package:flutter/material.dart';

class ProductDetails extends StatelessWidget {
  final String? img;
  final String? currentLocation;
  final String? namesPets;
  final String? price;
  final String? description;
  final Location? location;
  final List<String>? otherPics;

  const ProductDetails({
    super.key,
    this.img,
    this.currentLocation,
    this.namesPets,
    this.price,
    this.description,
    this.location, this.otherPics,
  });

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
          text: "Product Details",
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppSpacing.defaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 330,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: NetworkImage(img ?? ''),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              AppSpacing.heigthSpace20,
              Row(
                children: [
                  Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width * 0.08,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(5),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF000000).withOpacity(0.1),
                          offset: const Offset(0, 2.43),
                          blurRadius: 9.1,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: AppColors.primaryColor,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  const AppText(
                    text: "3",
                    fontWeight: FontWeight.w500,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Container(
                    height: 35,
                    width: MediaQuery.of(context).size.width * 0.08,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF000000).withOpacity(0.1),
                          offset: const Offset(0, 2.43),
                          blurRadius: 9.1,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: AppColors.primaryColor,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
              AppSpacing.heigthSpace20,
              Row(
                children: [
                  AppText(
                    text: "$price",
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                    height: 25,
                    width: MediaQuery.of(context).size.width * 0.2,
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Center(
                      child: AppText(
                        text: "Featured",
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                  )
                ],
              ),
              AppSpacing.heigthSpace20,
              const AppText(
                text: "Product Name here",
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor,
              ),
              if (currentLocation != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Color(0xff06393D),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        AppText(
                          text: "$currentLocation",
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xff06393D),
                        ),
                      ],
                    ),
                    const AppText(
                      text: "18/09/2022",
                      fontSize: 10,
                    ),
                  ],
                ),
              AppSpacing.heigthSpace20,
              Image.asset(
                "assets/images/product_images.png",
                height: 70,
              ),
              AppSpacing.heigthSpace20,
              const AppText(
                text: "Product Description",
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xff06393D),
              ),
              AppSpacing.heigthSpace20,
              const AppText(
                text:
                    "Lorem ipsum dolor sit amet consectetur adipisicing elit. Maxime mollitia, molestiae quas vel sint commodi repudiandae consequuntur voluptatum laborum numquam blanditiis harum quisquam eius sed odit fugiat iusto fuga praesentium optio, eaque rerum! Provident similique accusantium nemo autem. Veritatis obcaecati tenetur iure eius earum ut molestias architecto voluptate aliquam.",
                color: Color(0xff003034),
                fontSize: 12,
                fontWeight: FontWeight.w400,
              ),
              AppSpacing.heigthSpace20,
              AppButton(
                text: "Chat Now",
                onTap: () {},
              )
            ],
          ),
        ),
      ),
    );
  }
}
