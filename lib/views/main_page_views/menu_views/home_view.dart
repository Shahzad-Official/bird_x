import 'dart:convert';

import 'package:bird_x/constants/app_spacing.dart';
import 'package:bird_x/controllers/main_page_controllers/home_page_controller.dart';
import 'package:bird_x/main.dart';
import 'package:bird_x/models/user_model.dart';
import 'package:bird_x/services/local_db_service.dart';
import 'package:bird_x/services/product_services.dart';
import 'package:bird_x/services/registration_services.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/views/main_page_views/menu_views/categories_home.dart';
import 'package:bird_x/views/main_page_views/menu_views/prdouct_details.dart';
import 'package:bird_x/widgets/app_cached_image.dart';
import 'package:bird_x/widgets/app_field.dart';
import 'package:bird_x/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

String inviteLink = '';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final LocalDbService _localDbService = LocalDbService();
  final HomePageController _controller = Get.put(HomePageController());
  final ScrollController _scrollController = ScrollController();
  LoginModel userData = LoginModel();
  final ProductServices _services = ProductServices();

  bool isLoading = false;
  getData() async {
    setState(() {
      isLoading = true;
    });
    var data = jsonDecode(box.get("userData"));
    userData = LoginModel.fromJson(data);
    String inviteCode = userData.data!.referralCode.toString();
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
      appBar: AppBar(
        title: AppText(
          text: isLoading ? "loading..." : userData.data!.location!.address ?? "",
          color: Colors.black,
          fontSize: 17,
          fontWeight: FontWeight.w500,
        ),
        centerTitle: false,
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(
        //       top: 5,
        //       right: 10,
        //       bottom: 5,
        //     ),
        //     child: InkWell(
        //       onTap: () {
        //         AppNavigation.to(context, nextPage: const Notifications());
        //       },
        //       child: CircleAvatar(
        //         backgroundColor: Colors.white,
        //         child: SvgPicture.asset(
        //           "assets/icons/bell.svg",
        //         ),
        //       ),
        //     ),
        //   ),
        // ],
        bottom: isLoading
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
                  AppSpacing.heigthSpace30,
                  const AppText(
                    text: "Recent Recommendations",
                    fontSize: 16,
                    color: Color(0xff353535),
                  ),
                  AppSpacing.heigthSpace20,
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
                                    if (_.isSearching) {
                                      for (int i = 0; i < _.searchedProductList.length; i++) {
                                        _.checkedList.add(false);
                                      }
                                      _.checkedList[index] = _localDbService.isChecked(productData);
                                    } else {
                                      for (int i = 0; i < _.productList.length; i++) {
                                        _.checkedList.add(false);
                                      }
                                      _.checkedList[index] = _localDbService.isChecked(productData);
                                    }

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
                                                    var jsonData = productData.toJson();
                                                    if (_localDbService.isChecked(productData)) {
                                                      _localDbService.removeItem(jsonData);
                                                      _.changeCheck(index, false);
                                                    } else {
                                                      _localDbService.addItem(jsonData);
                                                      _.changeCheck(index, true);
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
