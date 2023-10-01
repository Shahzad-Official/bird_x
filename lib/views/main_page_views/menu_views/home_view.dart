import 'dart:convert';

import 'package:bird_x/constants/app_spacing.dart';
import 'package:bird_x/main.dart';
import 'package:bird_x/models/user_model.dart';
import 'package:bird_x/services/product_services.dart';
import 'package:bird_x/services/registration_services.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/views/main_page_views/menu_views/categories_home.dart';
import 'package:bird_x/views/main_page_views/menu_views/prdouct_details.dart';
import 'package:bird_x/views/notifications.dart/notifications.dart';
import 'package:bird_x/widgets/app_cached_image.dart';
import 'package:bird_x/widgets/app_field.dart';
import 'package:bird_x/widgets/app_shadowcontainer.dart';
import 'package:bird_x/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

String inviteLink = '';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
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
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
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
                  flex: 9,
                  child: AppText(
                    text: userData.data!.location!.address.toString(),
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: AppSpacing.defaultPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SearchField(
                      hintText: "Search",
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: SvgPicture.asset("assets/icons/search.svg"),
                      ),
                    ),
                    AppSpacing.heigthSpace30,
                    const AppText(
                      text: "Browse Categories",
                      fontSize: 16,
                      color: Color(0xff353535),
                    ),
                    AppSpacing.heigthSpace10,
                    InkWell(
                      onTap: () {
                        AppNavigation.to(context,
                            nextPage: const CategoriesHome());
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
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _services.allProductsModel.perPage,
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 4,
                              mainAxisSpacing: 4,
                              mainAxisExtent: 250),
                      itemBuilder: (BuildContext context, int index) {
                        final productData =
                            _services.allProductsModel.productData?[index];
                        final imageUrl = productData?.thumbnail ?? "";
                        final name = productData?.name ?? "";
                        final price = productData?.price ?? "";
                        final description = productData?.description ?? "";

                        return InkWell(
                          onTap: () {
                            AppNavigation.to(context,
                                nextPage: ProductDetails(
                                  // location: location,
                                  description: description,
                                  // otherPics: otherPics,
                                  namesPets: name,
                                  currentLocation: userData
                                      .data!.location!.address
                                      .toString(),
                                  img: imageUrl,
                                  price: price,
                                ));
                          },
                          child: Container(
                            height: 250,
                            width: MediaQuery.of(context).size.width * 0.45,
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xff000000).withOpacity(0.1),
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
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(right: 5, top: 3),
                                      child: Icon(
                                        Icons.favorite_border,
                                        color: Colors.white,
                                      ),
                                    )
                                  ],
                                ),
                                AppSpacing.heigthSpace10,
                                Padding(
                                  padding: const EdgeInsets.only(left: 11),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
  }
}
