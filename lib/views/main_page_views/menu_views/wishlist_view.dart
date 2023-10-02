import 'dart:convert';

import 'package:bird_x/constants/app_spacing.dart';
import 'package:bird_x/controllers/main_page_controllers/wishlist_controller.dart';
import 'package:bird_x/main.dart';
import 'package:bird_x/models/all_product_model.dart';
import 'package:bird_x/services/local_db_service.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/views/main_page_views/menu_views/prdouct_details.dart';
import 'package:bird_x/widgets/app_cached_image.dart';
import 'package:bird_x/widgets/app_field.dart';
import 'package:bird_x/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class WishlistView extends StatefulWidget {
  const WishlistView({Key? key}) : super(key: key);

  @override
  State<WishlistView> createState() => _WishlistViewState();
}

class _WishlistViewState extends State<WishlistView> {
  final WishlistController _controller = Get.put(WishlistController());
  final LocalDbService _localDbService = LocalDbService();
  getData() {
    List<ProductData> products = [];
    if (box.get("wishlist") != null) {
      List list = box.get("wishlist");
      for (var i in list) {
        var data = jsonDecode(jsonEncode(i));
        products.add(ProductData.fromJson(data));
      }
    }
    _controller.queryProduct(
      products: products,
    );
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WishlistController>(
        init: WishlistController(),
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              title: const AppText(
                text: "WishList",
              ),
              bottom: _controller.productList.isEmpty
                  ? null
                  : PreferredSize(
                      preferredSize: const Size.fromHeight(65),
                      child: Padding(
                        padding: AppSpacing.defaultPadding,
                        child: SearchField(
                          hintText: "Search",
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SvgPicture.asset("assets/icons/search.svg"),
                          ),
                        ),
                      ),
                    ),
            ),
            body: _controller.productList.isEmpty
                ? const Center(
                    child: AppText(
                      text: "No Data Found",
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                : SingleChildScrollView(
                    child: Padding(
                      padding: AppSpacing.defaultPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const AppText(
                            text: "Pets in WishList",
                            fontSize: 16,
                            color: Color(0xff353535),
                          ),
                          AppSpacing.heigthSpace20,
                          GridView.builder(
                            itemCount: _.productList.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4,
                              mainAxisExtent: 250,
                            ),
                            itemBuilder: (BuildContext context, int index) {
                              final productData = _.productList[index];
                              final imageUrl = productData.thumbnail ?? "";
                              final name = productData.name ?? "";
                              final price = productData.price ?? "";

                              for (int i = 0; i < _.productList.length; i++) {
                                _.checkedList.add(false);
                              }
                              _.checkedList[index] = _localDbService.isChecked(productData);

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
                                      Stack(
                                        alignment: AlignmentDirectional.topEnd,
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
                                          IconButton(
                                            onPressed: () {
                                              if (_localDbService.isChecked(productData)) {
                                                _.changeCheck(index, false, productData);
                                              } else {
                                                _.changeCheck(index, true, productData);
                                              }
                                            },
                                            icon: Icon(
                                              _.checkedList[index] ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                              color: _.checkedList[index] ? Colors.red : Colors.white,
                                            ),
                                          ),
                                        ],
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
                                              text: price,
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
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        });
  }
}
