import 'dart:convert';

import 'package:bird_x/constants/app_colors.dart';
import 'package:bird_x/constants/app_spacing.dart';
import 'package:bird_x/controllers/main_page_controllers/home_page_controller.dart';
import 'package:bird_x/controllers/main_page_controllers/product_controller.dart';
import 'package:bird_x/main.dart';
import 'package:bird_x/models/all_product_model.dart';
import 'package:bird_x/models/user_model.dart';
import 'package:bird_x/controllers/location_controller.dart';
import 'package:bird_x/services/product_services.dart';
import 'package:bird_x/services/registration_services.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/utils/intl_utils.dart';
import 'package:bird_x/views/main_page_views/menu_views/categories_home.dart';
import 'package:bird_x/views/main_page_views/menu_views/prdouct_details.dart';
import 'package:bird_x/widgets/app_cached_image.dart';
import 'package:bird_x/widgets/app_field.dart';
import 'package:bird_x/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:jiffy/jiffy.dart';

String inviteLink = '';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomePageController _controller = Get.put(HomePageController());
  final ScrollController _scrollController = ScrollController();
  LoginModel userData = LoginModel();
  final ProductServices _services = ProductServices();
  String address = "";
  bool isLoading = false;
  getData() async {
    setState(() {
      isLoading = true;
    });

    userData = box.get("userData") == null ? LoginModel() : LoginModel.fromJson(jsonDecode(box.get("userData")));
    if (userData.data == null) {
      await get(Uri.parse('http://ip-api.com/json')).then((value) {
        var data = jsonDecode(value.body);
        if (box.get("myAddress") == null) {
          box.put("myAddress", data['country']);
          address = data['country'];
        } else {
          address = "${box.get("myAddress")}";
        }
        box.put("myCountry", data['country']);
        box.put("myCountryCode", data['countryCode']);
      });
    } else {
      box.put("myAddress", userData.data!.location!.address.toString());
      address = userData.data!.location!.address.toString();
    }
    box.put("myCountry", userData.country == null ? "${box.get("myCountry")}" : userData.country!.countryName ?? "Pakistan");

    String inviteCode = userData.data == null ? "" : userData.data!.referralCode.toString();
    await RegistrationServices.generateLink(inviteCode).then(
      (value) {
        inviteLink = value;
      },
    ).catchError((err) {
      debugPrint("link creation error => $err");
    });

    await _services.getAllProducts();
    _controller.productList = _services.allProductsModel.productData ?? [];
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _controller.currentPage = 1;
    _scrollController.addListener(
      () {
        if (_scrollController.position.maxScrollExtent == _scrollController.offset) {
          _controller.paginateProducts();
        }
      },
    );
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: SizedBox(
      //     width: MediaQuery.of(context).size.width * 0.7,
      //     child: ExpansionTile(
      //       trailing: SizedBox(),
      //       title: AppText(
      //         text: isLoading
      //             ? "loading..."
      //             : userData.data == null
      //                 ? address
      //                 : userData.data!.location!.address ?? "",
      //         color: Colors.black,
      //         fontSize: 17,
      //         fontWeight: FontWeight.w500,
      //       ),
      //       children: [
      //         TextButton(
      //           onPressed: () async {
      //             await _locationService.pickCurrentLocation();
      //             setState(() {
      //               address = _locationService.currentAddress;
      //             });
      //           },
      //           child: AppText(text: "Use your current Location"),
      //         ),
      //       ],
      //     ),
      //   ),
      //   centerTitle: false,
      //   // actions: [
      //   //   Padding(
      //   //     padding: const EdgeInsets.only(
      //   //       top: 5,
      //   //       right: 10,
      //   //       bottom: 5,
      //   //     ),
      //   //     child: InkWell(
      //   //       onTap: () {
      //   //         AppNavigation.to(context, nextPage: const Notifications());
      //   //       },
      //   //       child: CircleAvatar(
      //   //         backgroundColor: Colors.white,
      //   //         child: SvgPicture.asset(
      //   //           "assets/icons/bell.svg",
      //   //         ),
      //   //       ),
      //   //     ),
      //   //   ),
      //   // ],
      //   bottom: isLoading
      //       ? null
      //       : PreferredSize(
      //           preferredSize: const Size.fromHeight(65),
      //           child: Padding(
      //             padding: const EdgeInsets.symmetric(
      //               vertical: 8.0,
      //               horizontal: 15,
      //             ),
      //             child: SearchField(
      //               controller: _controller.query,
      //               onSubmit: (value) {
      //                 _controller.queryProducts();
      //               },
      //               hintText: "Search",
      //               prefixIcon: Padding(
      //                 padding: const EdgeInsets.all(10.0),
      //                 child: SvgPicture.asset("assets/icons/search.svg"),
      //               ),
      //             ),
      //           ),
      //         ),
      // ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Padding(
                padding: AppSpacing.defaultPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Theme(
                      data: ThemeData().copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        title: GetBuilder<LocationController>(
                          init: LocationController(),
                          initState: (_) {},
                          builder: (_) {
                            return AppText(
                              text: _.currentAddress.isEmpty ? address : _.currentAddress,
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.w500,
                            );
                          },
                        ),
                        children: [
                          GetBuilder<LocationController>(
                            init: LocationController(),
                            initState: (_) {},
                            builder: (_) {
                              return TextButton(
                                onPressed: () async {
                                  setState(() {
                                    address = "Loading...";
                                  });
                                  await _.pickCurrentLocation();
                                  setState(() {
                                    address = _.currentAddress;
                                    box.put("myAddress", address);
                                  });
                                },
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.location_searching_rounded,
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    AppText(text: "Use your current Location"),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SearchField(
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
                    AppSpacing.heigthSpace10,
                    const AppText(
                      text: "Browse Categories",
                      fontSize: 16,
                      color: Color(0xff353535),
                    ),
                    AppSpacing.heigthSpace10,
                    InkWell(
                      onTap: () {
                        AppNavigation.to(context, nextPage: const CategoriesHome());
                      },
                      child: Container(
                        height: 48,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xff000000).withOpacity(0.1),
                              offset: const Offset(0, 4),
                              blurRadius: 15,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 15,
                            ),
                            SvgPicture.asset("assets/icons/category.svg"),
                            const SizedBox(
                              width: 20,
                            ),
                            const AppText(
                              text: "Select Category",
                              fontWeight: FontWeight.w300,
                            )
                          ],
                        ),
                      ),
                    ),
                    AppSpacing.heigthSpace20,
                    const AppText(
                      text: "Recent Recommendations",
                      fontSize: 16,
                      color: Color(0xff353535),
                    ),
                    AppSpacing.heigthSpace10,
                    Expanded(
                      child: GetBuilder<HomePageController>(
                        init: HomePageController(),
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
                            return RefreshIndicator(
                              onRefresh: () async {
                                await getData();
                              },
                              child: ListView.builder(
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
                                    return ProductWidget(
                                      products: _.isSearching ? _.searchedProductList : _.productList,
                                    );
                                  }
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class ProductWidget extends StatelessWidget {
  ProductWidget({
    super.key,
    this.isMe = false,
    required this.products,
    this.physics = const NeverScrollableScrollPhysics(),
  });

  final bool isMe;
  final List<ProductData> products;
  final ScrollPhysics? physics;
  final ProductController _controller = Get.put(ProductController());

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: products.length,
      physics: physics,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, index) {
        final productData = products[index];
        _controller.addDataToCheckList(
          index: index,
          productData: productData,
          products: products,
        );
        return GetBuilder<ProductController>(
          init: ProductController(),
          initState: (_) {},
          builder: (_) {
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
                    Expanded(
                      flex: 3,
                      child: Stack(
                        alignment: AlignmentDirectional.topEnd,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            child: AppCachedImage(
                              url: productData.thumbnail.toString(),
                              fit: BoxFit.cover,
                            ),
                          ),
                          isMe
                              ? const SizedBox()
                              : IconButton.filled(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateColor.resolveWith(
                                      (states) => Colors.black.withOpacity(0.5),
                                    ),
                                  ),
                                  onPressed: () {
                                    _.onFavorite(
                                      productData: productData,
                                      index: index,
                                    );
                                  },
                                  icon: Icon(
                                    _.checkedList[index] ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                    color: _.checkedList[index] ? Colors.red : Colors.white,
                                  ),
                                ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 11),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AppText(
                              text: IntlUtils.formatedPrice(
                                price: productData.price.toString(),
                              ),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryColor,
                            ),
                            AppText(
                              text: IntlUtils.capitalizeEachWord(productData.name.toString()),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              maxLines: 1,
                              overFlow: TextOverflow.ellipsis,
                            ),
                            AppText(
                              text: productData.user!.location!.address.toString(),
                              fontSize: 10,
                              fontWeight: FontWeight.w400,
                            ),
                            AppText(
                              text: Jiffy.parse(productData.startDate.toString()).fromNow(),
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
