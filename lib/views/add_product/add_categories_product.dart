import 'package:bird_x/constants/app_spacing.dart';
import 'package:bird_x/services/product_services.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/views/add_product/add_product.dart';
import 'package:bird_x/widgets/app_network_svg.dart';
import 'package:bird_x/widgets/app_shadowcontainer.dart';
import 'package:flutter/material.dart';

import '../../widgets/app_text.dart';

class CategoriesAddProduct extends StatefulWidget {
  const CategoriesAddProduct({super.key});

  @override
  State<CategoriesAddProduct> createState() => _CategoriesAddProductState();
}

class _CategoriesAddProductState extends State<CategoriesAddProduct> {
  final ProductServices _productServices = ProductServices();
  bool isLoading = false;
  getData() async {
    setState(() {
      isLoading = true;
    });
    await _productServices.fetchCategories();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(text: "Choose a Category"),
      ),
      body: Padding(
        padding: AppSpacing.defaultPadding,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Builder(
                builder: (context) {
                  final categories = _productServices.categoryModel.data;

                  if (categories == null || categories.isEmpty) {
                    return const Text('No data available');
                  } else {
                    return ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              AppNavigation.to(
                                context,
                                nextPage: AddProduct(
                                  categoryName: category.categoryName.toString(),
                                  categoryIcon: category.categoryIcon.toString(),
                                  categoryId: category.sId.toString(),
                                ),
                              );
                            },
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
                                            child: AppCachedSvg(
                                              url: category.categoryIcon.toString(),
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
