import 'package:bird_x/constants/app_colors.dart';
import 'package:bird_x/constants/app_spacing.dart';
import 'package:bird_x/controllers/main_page_controllers/product_details_controller.dart';
import 'package:bird_x/models/all_product_model.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/utils/date_utils.dart';
import 'package:bird_x/utils/intl_utils.dart';
import 'package:bird_x/views/chat_screens/chat_screen.dart';
import 'package:bird_x/widgets/app_button.dart';
import 'package:bird_x/widgets/app_cached_image.dart';
import 'package:bird_x/widgets/app_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProductDetails extends StatelessWidget {
  final ProductData productData;
  ProductDetails({
    super.key,
    required this.productData,
  });
  final CarouselController _pageController = CarouselController();
  @override
  Widget build(BuildContext context) {
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
                  // Container(
                  //   height: 25,
                  //   width: MediaQuery.of(context).size.width * 0.2,
                  //   decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(20)),
                  //   child: const Center(
                  //     child: AppText(
                  //       text: "Featured",
                  //       color: Colors.white,
                  //       fontSize: 10,
                  //     ),
                  //   ),
                  // )
                ],
              ),
              AppSpacing.heigthSpace10,
              AppText(
                text: productData.name.toString(),
                fontWeight: FontWeight.w500,
                color: AppColors.primaryColor,
                fontSize: 18,
              ),
              AppSpacing.heigthSpace10,
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
                height: 250,
                width: double.maxFinite,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: GoogleMap(
                    myLocationButtonEnabled: false,
                    onTap: (argument) {
                      AppNavigation.to(
                        context,
                        nextPage: GoogleMapPage(
                          latLng: argument,
                        ),
                      );
                    },
                    myLocationEnabled: true,
                    markers: {
                      Marker(
                        markerId: const MarkerId("1"),
                        position: LatLng(
                          double.parse(productData.location!.latitude ?? ""),
                          double.parse(productData.location!.longitude ?? ""),
                        ),
                      ),
                    },
                    initialCameraPosition: CameraPosition(
                      zoom: 14,
                      target: LatLng(
                        double.parse(productData.location!.latitude ?? ""),
                        double.parse(productData.location!.longitude ?? ""),
                      ),
                    ),
                  ),
                ),
              ),
              AppSpacing.heigthSpace20,
              const AppText(
                text: "Product Description",
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xff06393D),
              ),
              AppSpacing.heigthSpace20,
              AppText(
                text: productData.description.toString(),
                color: const Color(0xff003034),
                fontSize: 12,
                fontWeight: FontWeight.w400,
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
