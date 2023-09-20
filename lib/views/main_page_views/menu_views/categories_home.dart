import 'package:bird_x/constants/app_spacing.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/views/notifications.dart/notifications.dart';
import 'package:bird_x/widgets/app_shadowcontainer.dart';
import 'package:bird_x/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../models/category_model.dart';

class CategoriesHome extends StatefulWidget {
  const CategoriesHome({super.key});

  @override
  State<CategoriesHome> createState() => _CategoriesHomeState();
}

class _CategoriesHomeState extends State<CategoriesHome> {
  List<Category> categories = [
    {
      "id": "1",
      "categoryName": "Pigeon",
      "categoryIcon": "icon/Pigeon1695041577706.svg",
      "color": "28dd00",
      "createdOn": "2023-09-18T12:52:57.709Z",
    },
    {
      "id": "2",
      "categoryName": "Parrot",
      "categoryIcon": "icon/Parrot1695041910354.svg",
      "color": "00ffa1",
      "createdOn": "2023-09-18T12:58:30.357Z",
    },
    {
      "id": "3",
      "categoryName": "Chicken",
      "categoryIcon": "icon/Chicken1695042097877.svg",
      "color": "ef5623",
      "createdOn": "2023-09-18T13:01:37.879Z"
    },
    {
      "id": "4",
      "categoryName": "Cats",
      "categoryIcon": "icon/Cats1695042398816.svg",
      "color": "00ffbf",
      "createdOn": "2023-09-18T13:06:38.819Z"
    },
    {
      "id": "5",
      "categoryName": "Dogs",
      "categoryIcon": "icon/Dogs1695042817527.svg",
      "color": "1d00ff",
      "createdOn": "2023-09-18T13:13:37.529Z"
    },
    {
      "id": "6",
      "categoryName": "Fish",
      "categoryIcon": "icon/Fish1695043189104.svg",
      "color": "00aeff",
      "createdOn": "2023-09-18T13:19:49.106Z"
    },
    {
      "id": "7",
      "categoryName": "Rabbit",
      "categoryIcon": "icon/Rabbit1695043239825.svg",
      "color": "bf00ff",
      "createdOn": "2023-09-18T13:20:39.828Z"
    },
    {
      "id": "8",
      "categoryName": "Other",
      "categoryIcon": "icon/Other1695043330512.svg",
      "color": "24dd00",
      "createdOn": "2023-09-18T13:22:10.514Z"
    }
  ].map((data) {
    return Category(
      id: data["id"] ?? "",
      categoryName: data["categoryName"] ?? "",
      categoryIcon: data["categoryIcon"] ?? "",
      color: data["color"] ?? "",
      createdOn: data["createdOn"] ?? "",
    );
  }).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: InkWell(
                        onTap: () {
                          AppNavigation.back(context);
                        },
                        child: const Icon(Icons.arrow_back_ios_new))),
                const Flexible(
                    flex: 9,
                    child: AppText(
                      text: "Choose Category",
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    )),
                Flexible(
                  child: InkWell(
                    onTap: () {
                      AppNavigation.to(context,
                          nextPage: const Notifications());
                    },
                    child: AppShadowcontainer(
                      child: SvgPicture.asset(
                        "assets/icons/bell.svg",
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Padding(
        padding: AppSpacing.defaultPadding,
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 55,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 45,
                                width: 45,
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                ),
                                child: SvgPicture.asset(category.categoryIcon),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              AppText(text: category.categoryName),
                            ],
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: Color(0xffABAAAA),
                            size: 14,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
