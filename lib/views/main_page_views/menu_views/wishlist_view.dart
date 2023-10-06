import 'dart:convert';

import 'package:bird_x/constants/app_spacing.dart';
import 'package:bird_x/controllers/main_page_controllers/wishlist_controller.dart';
import 'package:bird_x/main.dart';
import 'package:bird_x/models/all_product_model.dart';
import 'package:bird_x/views/main_page_views/menu_views/home_view.dart';
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
                          ProductWidget(
                            products: _.productList,
                          ),
                        ],
                      ),
                    ),
                  ),
          );
        });
  }
}
