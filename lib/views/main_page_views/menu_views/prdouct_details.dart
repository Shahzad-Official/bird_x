import 'package:bird_x/constants/app_colors.dart';
import 'package:bird_x/constants/app_spacing.dart';
import 'package:bird_x/controllers/main_page_controllers/product_details_controller.dart';
import 'package:bird_x/models/all_product_model.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/utils/app_snackbar.dart';
import 'package:bird_x/utils/date_utils.dart';
import 'package:bird_x/utils/intl_utils.dart';
import 'package:bird_x/views/chat_screens/chat_screen.dart';
import 'package:bird_x/widgets/app_button.dart';
import 'package:bird_x/widgets/app_cached_image.dart';
import 'package:bird_x/widgets/app_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProductDetails extends StatelessWidget {
  final ProductData productData;
  ProductDetails({
    super.key,
    required this.productData,
  });
  final CarouselController _pageController = CarouselController();
  final List<String> safetyRules = [
    "Only meet in public / crowded places.",
    "Ask for identification and verify the identity of seller / buyer.",
    "Never go alone to meet a buyer / seller , always take someone with you.",
    "When buying a pet, inspect it carefully, looking for any signs of illness or injury.",
    "Request information about the pet's history, vaccinations, and health records.",
    "Never pay in advance before complete inspection.",
  ];

  @override
  Widget build(BuildContext context) {
    LatLng latLng = LatLng(double.parse(productData.location!.latitude.toString()), double.parse(productData.location!.longitude.toString()));
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              AppNavigation.back(context);
            },
            child: const Icon(Icons.arrow_back_ios_new)),
        title: const AppText(
          text: "Product Details",
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppSpacing.defaultPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              productData.otherPics == null || productData.otherPics!.isEmpty
                  ? AppCachedImage(
                      height: 250,
                      width: double.infinity,
                      url: productData.thumbnail.toString(),
                      fit: BoxFit.cover,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(15),
                    )
                  : Column(
                      children: [
                        GetBuilder<ProductDetailsController>(
                          init: ProductDetailsController(),
                          initState: (_) {},
                          builder: (_) {
                            return CarouselSlider.builder(
                              carouselController: _pageController,
                              itemCount: productData.otherPics?.length,
                              itemBuilder: (context, index, realIndex) {
                                return AppCachedImage(
                                  height: 250,
                                  width: double.infinity,
                                  url: productData.otherPics![index].toString(),
                                  fit: BoxFit.cover,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(15),
                                );
                              },
                              options: CarouselOptions(
                                viewportFraction: 0.8,
                                height: 250,
                                enlargeCenterPage: true,
                                onPageChanged: (index, reason) {
                                  _.changeIndex(index);
                                },
                              ),
                            );
                          },
                        ),
                        AppSpacing.heigthSpace20,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOutCubic,
                                );
                              },
                              child: Container(
                                height: 35,
                                width: MediaQuery.of(context).size.width * 0.08,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF000000).withOpacity(0.1),
                                      offset: const Offset(0, 2.43),
                                      blurRadius: 9.1,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.arrow_back_ios_new,
                                    color: AppColors.primaryColor,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            GetBuilder<ProductDetailsController>(
                              init: ProductDetailsController(),
                              initState: (_) {},
                              builder: (_) {
                                return AppText(
                                  text: "${_.currentIndex + 1}",
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.primaryColor,
                                );
                              },
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            InkWell(
                              onTap: () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.ease,
                                );
                              },
                              child: Container(
                                height: 35,
                                width: MediaQuery.of(context).size.width * 0.08,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF000000).withOpacity(0.1),
                                      offset: const Offset(0, 2.43),
                                      blurRadius: 9.1,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: AppColors.primaryColor,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
              AppSpacing.heigthSpace20,
              Row(
                children: [
                  AppText(
                    text: IntlUtils.formatedPrice(price: productData.price ?? "0"),
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
              AppSpacing.heigthSpace10,
              AppText(
                text: productData.name.toString(),
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor,
                fontSize: 18,
              ),
              AppSpacing.heigthSpace20,
              const AppText(
                text: "Pet Description",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xff06393D),
              ),
              AppSpacing.heigthSpace10,
              GetBuilder<ProductDetailsController>(
                init: ProductDetailsController(),
                initState: (_) {},
                builder: (_) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        text: productData.description.toString(),
                        color: const Color(0xff003034),
                        fontWeight: FontWeight.w400,
                        maxLines: !_.isReadMore ? null : 3,
                      ),
                      AppSpacing.heigthSpace10,
                      InkWell(
                        onTap: () {
                          _.changeReadMore();
                        },
                        child: Row(
                          children: [
                            AppText(
                              text: _.isReadMore ? "Read More" : "Read Less",
                              fontWeight: FontWeight.w700,
                            ),
                            Icon(
                              _.isReadMore ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_up_rounded,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
              AppSpacing.heigthSpace30,
              Row(
                children: [
                  SizedBox(
                    height: 70,
                    width: 70,
                    child: AppCachedImage(
                      height: 70,
                      width: 70,
                      shape: BoxShape.circle,
                      url: productData.user!.profile.toString(),
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          text: "${productData.user!.firstName} ${productData.user!.lastName}",
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: AppText(
                                text: "${productData.user!.mobileCode}${productData.user!.mobile}",
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: "${productData.user!.mobileCode}${productData.user!.mobile}")).then((value) {
                                  AppSnackbar.showSnackbar(
                                    title: "Message",
                                    message: "Phone Number Copied to clipboard!",
                                  );
                                });
                              },
                              icon: const Icon(
                                Icons.copy_rounded,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              AppSpacing.heigthSpace30,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          color: Color(0xff06393D),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Flexible(
                          child: AppText(
                            text: "${productData.location!.address} ",
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff06393D),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppText(
                    text: AppDateUtils.formatDate(
                      pattern: "dd/MM/yyyy",
                      date: productData.endDate.toString(),
                    ),
                    fontSize: 14,
                  ),
                ],
              ),
              AppSpacing.heigthSpace10,
              SizedBox(
                height: 150,
                width: double.maxFinite,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    children: [
                      GoogleMap(
                        zoomControlsEnabled: false,
                        myLocationButtonEnabled: false,
                        onTap: (argument) {
                          AppNavigation.to(
                            context,
                            nextPage: GoogleMapPage(
                              latLng: argument,
                            ),
                          );
                        },
                        initialCameraPosition: CameraPosition(
                          zoom: 14,
                          target: LatLng(
                            double.parse(productData.location!.latitude ?? ""),
                            double.parse(productData.location!.longitude ?? ""),
                          ),
                        ),
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            AppNavigation.to(
                              context,
                              nextPage: GoogleMapPage(
                                latLng: latLng,
                              ),
                            );
                          },
                          child: Container(
                            width: 160,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                AppText(
                                  text: "See Location",
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AppSpacing.heigthSpace20,
              const AppText(
                text: "Your safety maters to us!",
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              AppSpacing.heigthSpace5,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(
                    safetyRules.length,
                    (index) => Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: Row(
                        children: [
                          const AppText(
                            text: "\u2022  ",
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                          Flexible(
                            child: AppText(
                              text: safetyRules[index],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              AppSpacing.heigthSpace20,
              AppButton(
                text: "Chat Now",
                onTap: () {
                  AppNavigation.to(
                    context,
                    nextPage: ChatScreen(
                      userData: productData.user!,
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

class GoogleMapPage extends StatelessWidget {
  final LatLng latLng;
  const GoogleMapPage({Key? key, required this.latLng}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(text: "Google Map"),
      ),
      body: GoogleMap(
        myLocationButtonEnabled: false,
        myLocationEnabled: true,
        markers: {
          Marker(
            markerId: const MarkerId("1"),
            position: latLng,
          ),
        },
        initialCameraPosition: CameraPosition(
          zoom: 14,
          target: latLng,
        ),
      ),
    );
  }
}
