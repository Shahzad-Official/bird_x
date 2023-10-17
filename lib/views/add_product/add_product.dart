import 'dart:convert';
import 'dart:io';

import 'package:bird_x/constants/app_colors.dart';
import 'package:bird_x/constants/app_spacing.dart';
import 'package:bird_x/controllers/add_product_controoler/add_product_controler.dart';
import 'package:bird_x/main.dart';
import 'package:bird_x/models/user_model.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/widgets/app_button.dart';
import 'package:bird_x/widgets/app_field.dart';
import 'package:bird_x/widgets/app_network_svg.dart';
import 'package:bird_x/widgets/app_shadowcontainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/app_text.dart';

class AddProduct extends StatefulWidget {
  final String categoryName;
  final String categoryIcon;
  final String categoryId;

  const AddProduct({super.key, required this.categoryName, required this.categoryIcon, required this.categoryId});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  LoginModel userData = LoginModel.fromJson(jsonDecode(box.get("userData")));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(text: "Sell your Pet"),
      ),
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(100),
      //   child: SafeArea(
      //     child: Padding(
      //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      //       child: Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //         children: [
      //           Flexible(
      //               child: InkWell(
      //                   onTap: () {
      //                     AppNavigation.back(context);
      //                   },
      //                   child: const Icon(Icons.arrow_back_ios_new))),
      //           const Flexible(
      //               flex: 3,
      //               child: AppText(
      //                 text: "Sell your pet ",
      //                 fontSize: 20,
      //                 fontWeight: FontWeight.w500,
      //               )),
      //           const Flexible(child: SizedBox())
      //         ],
      //       ),
      //     ),
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppSpacing.defaultPadding,
          child: GetBuilder<AddProductController>(
            init: AddProductController(),
            initState: (_) {},
            builder: (_) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    text: "Add Thumnail of your Pet *",
                    fontWeight: FontWeight.w500,
                  ),
                  AppSpacing.heigthSpace10,
                  InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.white,
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    AppNavigation.back(context);
                                    _.pickThumbnail(source: ImageSource.camera);
                                  },
                                  child: const SizedBox(
                                    height: 120,
                                    child: Column(
                                      children: [
                                        AppShadowcontainer(
                                          child: Icon(
                                            Icons.camera_alt_outlined,
                                          ),
                                        ),
                                        AppSpacing.heigthSpace10,
                                        AppText(
                                          text: "Camera",
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        AppSpacing.heigthSpace10,
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    AppNavigation.back(context);
                                    _.pickThumbnail(source: ImageSource.gallery);
                                  },
                                  child: const SizedBox(
                                    height: 120,
                                    child: Column(
                                      children: [
                                        AppShadowcontainer(
                                          child: Icon(
                                            Icons.photo_outlined,
                                          ),
                                        ),
                                        AppSpacing.heigthSpace10,
                                        AppText(
                                          text: "Gallery",
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        AppSpacing.heigthSpace10,
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            width: double.maxFinite,
                            height: 200.0,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.primaryColor.withOpacity(0.7),
                                  Colors.grey.withOpacity(0.7),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(),
                              image: _.thumbnailImage == null
                                  ? null
                                  : DecorationImage(
                                      fit: BoxFit.cover,
                                      image: FileImage(_.thumbnailImage!),
                                    ),
                            ),
                            child: const SizedBox(),
                          ),
                        ),
                        if (_.thumbnailImage == null)
                          Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                              border: Border.all(width: 1.5),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.add,
                                size: 24,
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                  AppSpacing.heigthSpace30,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const AppText(
                        text: "Add Multiple Images *",
                        fontWeight: FontWeight.w500,
                      ),
                      _.multiImages.isEmpty
                          ? const SizedBox()
                          : AppText(
                              text: _.multiImages.length.toString(),
                              fontWeight: FontWeight.w600,
                            ),
                    ],
                  ),
                  AppSpacing.heigthSpace20,
                  GestureDetector(
                    onTap: () {
                      _.multiimagePicked();
                    },
                    child: Stack(
                      alignment: AlignmentDirectional.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.primaryColor.withOpacity(0.7),
                                  Colors.grey.withOpacity(0.7),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(),
                            ),
                            width: double.maxFinite,
                            height: 200.0,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _.multiImages.length,
                              itemBuilder: (context, index) {
                                final File imageFile = _.multiImages[index];
                                return Container(
                                  width: MediaQuery.of(context).size.width * 0.85,
                                  height: 200.0,
                                  margin: const EdgeInsets.all(5),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      imageFile,
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width * 1,
                                      height: 200.0,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        _.multiImages.isEmpty
                            ? Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  border: Border.all(width: 1.5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(Icons.add),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                  AppSpacing.heigthSpace20,
                  Focus(
                    onFocusChange: (value) {
                      _.changeFocus(value);
                    },
                    child: AppField(
                      hintText: "Price",
                      controller: _.price,
                      isRequired: true,
                      textType: TextInputType.number,
                      prefixIcon: SizedBox(
                        height: 40,
                        width: 20,
                        child: Center(
                          child: AppText(
                            text: userData.country == null ? "RS" : userData.country!.currencySymbol.toString(),
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            color: _.isFocused ? AppColors.primaryColor : const Color.fromARGB(255, 137, 137, 137),
                          ),
                        ),
                      ),
                    ),
                  ),
                  AppSpacing.heigthSpace20,
                  const AppText(
                    text: "Category",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  AppSpacing.heigthSpace10,
                  Container(
                    height: 60,
                    width: double.infinity,
                    decoration: const BoxDecoration(),
                    child: Row(
                      children: [
                        Container(
                          height: 55,
                          width: 55,
                          decoration: BoxDecoration(border: Border.all(width: 0.1), shape: BoxShape.circle),
                          child: Center(
                            child: AppCachedSvg(
                              height: 45,
                              width: 45,
                              url: widget.categoryIcon,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AppText(
                              text: widget.categoryName,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  AppSpacing.heigthSpace20,
                  AppField(
                    readOnly: true,
                    controller: _.location,
                    onTap: () async {
                      await _.pickLocation(context);
                    },
                    suffixIcon: const Icon(
                      Icons.location_on_outlined,
                    ),
                  ),
                  AppSpacing.heigthSpace20,
                  AppField(
                    hintText: "Add Title",
                    isRequired: true,
                    prefixIcon: const Icon(Icons.title_outlined),
                    controller: _.title,
                  ),
                  AppSpacing.heigthSpace20,
                  AppField(
                    maxLines: 10,
                    hintText: "Describe what are you seling",
                    isRequired: true,
                    controller: _.description,
                  ),
                  AppSpacing.heigthSpace30,
                  AppButton(
                    text: "Next",
                    isLoading: _.isLoading,
                    onTap: () async {
                      await _.addProduct(context, categoryName: widget.categoryName, categoryId: widget.categoryId);
                    },
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
