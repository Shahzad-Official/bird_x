import 'package:bird_x/constants/api_constant.dart';
import 'package:bird_x/constants/app_spacing.dart';
import 'package:bird_x/models/category_model.dart';
import 'package:bird_x/services/product_services.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/views/notifications.dart/notifications.dart';
import 'package:bird_x/widgets/app_shadowcontainer.dart';
import 'package:bird_x/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CategoriesHome extends StatefulWidget {
  const CategoriesHome({super.key});

  @override
  State<CategoriesHome> createState() => _CategoriesHomeState();
}

class _CategoriesHomeState extends State<CategoriesHome> {
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
                    child: const Icon(Icons.arrow_back_ios_new),
                  ),
                ),
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
        child: FutureBuilder<CategoryModel>(
          future: ProductServices().fetchCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final categories = snapshot.data?.data;

              if (categories == null || categories.isEmpty) {
                return const Text('No data available');
              }

              return ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {},
                      child: AppShadowcontainer(
                        shape: BoxShape.rectangle,
                        height: 60,
                        width: double.infinity,
                        child: Container(
                          height: 60,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withOpacity(0.9),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  Container(
                                    height: 45,
                                    width: 45,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 0.1,
                                        ),
                                        shape: BoxShape.circle),
                                    child: Center(
                                      child: SvgPicture.network(
                                        "${ApiConstant.baseUrl}/${category.categoryIcon!}",
                                        height: 30,
                                        width: 30,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  AppText(
                                    text: "${category.categoryName} ",
                                    fontSize: 16,
                                  ),
                                ],
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 12),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Color(0xffABAAAA),
                                  size: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
