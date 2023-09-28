import 'dart:convert';

import 'package:bird_x/constants/app_spacing.dart';
import 'package:bird_x/main.dart';
import 'package:bird_x/models/category_model.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/views/notifications.dart/notifications.dart';
import 'package:bird_x/widgets/app_shadowcontainer.dart';
import 'package:bird_x/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;

class CategoriesHome extends StatefulWidget {
  const CategoriesHome({super.key});

  @override
  State<CategoriesHome> createState() => _CategoriesHomeState();
}

class _CategoriesHomeState extends State<CategoriesHome> {
  Future<CategoryModel> fetchData() async {
    final token = box.get("token");
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final response = await http.get(
      Uri.parse('http://api.hexon.online:8080/api/categories'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      return CategoryModel.fromJson(jsonResponse);
    } else {
      print('HTTP Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');
      throw Exception('Failed to load data');
    }
  }

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
        child: FutureBuilder<CategoryModel>(
          future: fetchData(),
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
                              const SizedBox(
                                width: 15,
                              ),
                              AppText(
                                text: "${category.categoryName} ",
                              ),
                              SvgPicture.asset(category.categoryIcon ?? ""),
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
              );
            }
          },
        ),
      ),
    );
  }
}
