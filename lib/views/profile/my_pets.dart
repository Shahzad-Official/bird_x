import 'dart:convert';

import 'package:bird_x/constants/app_spacing.dart';
import 'package:bird_x/controllers/profile_controllers/my_pets_controller.dart';
import 'package:bird_x/main.dart';
import 'package:bird_x/models/category_model.dart';
import 'package:bird_x/models/user_model.dart';
import 'package:bird_x/services/product_services.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/utils/intl_utils.dart';
import 'package:bird_x/views/main_page_views/menu_views/prdouct_details.dart';
import 'package:bird_x/widgets/app_cached_image.dart';
import 'package:bird_x/widgets/app_field.dart';
import 'package:bird_x/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MyPets extends StatefulWidget {
  final CategoryData? categoryData;
  const MyPets({Key? key, this.categoryData}) : super(key: key);

  @override
  State<MyPets> createState() => _MyPetsState();
}

class _MyPetsState extends State<MyPets> {
  CategoryData? get category => widget.categoryData;
  final ScrollController _scrollController = ScrollController();
  final MyPetsController _controller = Get.put(MyPetsController());
  LoginModel userData = LoginModel();
  final ProductServices _services = ProductServices();
  bool isLoading = false;
  getData() async {
    setState(() {
      isLoading = true;
    });
    var data = jsonDecode(box.get("userData"));
    userData = LoginModel.fromJson(data);
    if (category == null) {
      await _services.getAllProducts(
        userId: userData.data!.sId.toString(),
      );
    } else {
      await _services.getAllProducts(
        categoryId: category!.sId.toString(),
      );
    }

    _controller.productList = _services.allProductsModel.productData ?? [];
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _scrollController.addListener(
      () {
        if (_scrollController.position.maxScrollExtent == _scrollController.offset) {
          if (category == null) {
            _controller.paginateProducts(
              userId: userData.data!.sId.toString(),
            );
          } else {
            _controller.paginateProducts(
              catId: category!.sId.toString(),
            );
          }
        }
      },
    );
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppText(
          text: category == null ? "My Pets" : category!.categoryName.toString(),
          color: Colors.black,
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
        bottom: isLoading || _controller.productList.isEmpty
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(65),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 15,
                  ),
                  child: SearchField(
                    controller: _controller.query,
                    onSubmit: (value) {
                      _controller.queryProducts();
                    },
                    hintText: "Search",
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SvgPicture.asset("assets/icons/search.svg"),
                    ),
                  ),
                ),
              ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: AppSpacing.defaultPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppSpacing.heigthSpace20,
                  Expanded(
                    child: GetBuilder<MyPetsController>(
                      init: MyPetsController(),
                      initState: (_) {},
                      builder: (_) {
                        if (_.productList.isEmpty) {
                          return const Center(
                            child: AppText(
                              text: "No Data Found!",
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        } else {
                          return ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemCount: 2,
                            itemBuilder: (context, ind) {
                              if (ind == 1) {
                                return !_.isLoading
                                    ? const SizedBox()
                                    : const Center(
                                        child: CircularProgressIndicator(),
                                      );
                              } else {
                                return GridView.builder(
                                  itemCount: _.isSearching ? _.searchedProductList.length : _.productList.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 4,
                                    mainAxisSpacing: 4,
                                    mainAxisExtent: 250,
                                  ),
                                  itemBuilder: (BuildContext context, int index) {
                                    final productData = _.isSearching ? _.searchedProductList[index] : _.productList[index];
                                    final imageUrl = productData.thumbnail ?? "";
                                    final name = productData.name ?? "";
                                    final price = productData.price ?? "";

                                    return InkWell(
                                      onTap: () {
                                        AppNavigation.to(
                                          context,
                                          nextPage: ProductDetails(
                                            productData: productData,
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 250,
                                        width: MediaQuery.of(context).size.width * 0.45,
                                        margin: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: const Color(0xff000000).withOpacity(0.1),
                                              offset: const Offset(0, 4),
                                              blurRadius: 15,
                                              spreadRadius: 0,
                                            ),
                                          ],
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.white,
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            ClipRRect(
                                              borderRadius: const BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                topRight: Radius.circular(10),
                                              ),
                                              child: AppCachedImage(
                                                height: 180,
                                                url: imageUrl,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                            AppSpacing.heigthSpace10,
                                            Padding(
                                              padding: const EdgeInsets.only(left: 11),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  AppText(
                                                    text: name,
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                  AppText(
                                                    text: IntlUtils.formatedPrice(price: price),
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
