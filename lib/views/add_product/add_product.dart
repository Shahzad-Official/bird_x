import 'dart:io';

import 'package:bird_x/constants/app_spacing.dart';
import 'package:bird_x/controllers/add_product_controoler/add_product_controler.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/widgets/app_button.dart';
import 'package:bird_x/widgets/app_field.dart';
import 'package:bird_x/widgets/app_shadowcontainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/app_text.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: InkWell(
                        onTap: () {
                          AppNavigation.back(context);
                        },
                        child: const Icon(Icons.arrow_back_ios_new))),
                const Flexible(
                    flex: 3,
                    child: AppText(
                      text: "Sell your pet ",
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    )),
                const Flexible(child: SizedBox())
              ],
            ),
          ),
        ),
      ),
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
                        text: "Add Thumnail of your Pet",
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        AppNavigation.back(context);
                                        _.pickProfile(
                                            source: ImageSource.camera);
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
                                        _.pickProfile(
                                            source: ImageSource.gallery);
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
                            AppShadowcontainer(
                              shape: BoxShape.rectangle,
                              width: double.infinity,
                              height: 170,
                              child: Container(
                                height: 170,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: _.thumnail == null
                                          ? const AssetImage(
                                              "assets/images/placeholder2.jpg",
                                            )
                                          : FileImage(_.thumnail!)
                                              as ImageProvider,
                                    )),
                                child: const SizedBox(),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (_.thumnail == null)
                                  Container(
                                    height: 35,
                                    width: 35,
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
                                  ),
                              ],
                            )
                          ],
                        ),
                      ),
                      AppSpacing.heigthSpace30,
                      const AppText(
                        text: "Add Multiple Images",
                        fontWeight: FontWeight.w500,
                      ),
                      AppSpacing.heigthSpace20,
                      GestureDetector(
                        onTap: () {
                          _.multiimagePicked();
                        },
                        child: Stack(
                          alignment: AlignmentDirectional.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: Colors.blueGrey),
                              width: MediaQuery.of(context).size.width * 0.965,
                              height: 200.0,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _.multiImages.length,
                                itemBuilder: (context, index) {
                                  final File? imageFile = _.multiImages[index];
                                  return Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    height: 200.0,
                                    margin: const EdgeInsets.all(2.0),
                                    child: imageFile != null
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: Image.file(
                                              imageFile,
                                              fit: BoxFit.cover,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  1,
                                              height: 200.0,
                                            ),
                                          )
                                        : Image.asset(
                                            "assets/images/placeholder2.jpg",
                                            fit: BoxFit.cover,
                                          ),
                                  );
                                },
                              ),
                            ),
                            Container(
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
                          ],
                        ),
                      ),
                      AppSpacing.heigthSpace20,
                      AppField(
                        hintText: "Price",
                        prefixIcon: const Icon(Icons.attach_money_rounded),
                        controller: _.price,
                      ),
                      AppSpacing.heigthSpace20,
                      const AppText(
                        text: "Category",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      Container(
                        height: 60,
                        width: double.infinity,
                        decoration: const BoxDecoration(),
                        child: Row(
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.network(
                                  "https://images.freeimages.com/images/large-previews/e5d/it-s-a-squirrel-1410688.jpg?fmt=webp&w=350",
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                )),
                            const SizedBox(
                              width: 20,
                            ),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AppText(
                                  text: "Fish",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                AppText(
                                  text: "Fish Company LTD",
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.brown,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      AppSpacing.heigthSpace20,
                      AppField(
                        controller: _.location,
                        onTap: () {},
                        suffixIcon: const Icon(
                          Icons.location_on_outlined,
                        ),
                      ),
                      AppSpacing.heigthSpace20,
                      AppField(
                        hintText: "Add Title",
                        prefixIcon: const Icon(Icons.title_outlined),
                        controller: _.title,
                      ),
                      AppSpacing.heigthSpace20,
                      AppField(
                        hintText: "Describe what are you seling",
                        prefixIcon: const Icon(Icons.sell),
                        controller: _.description,
                      ),
                      AppSpacing.heigthSpace30,
                      AppButton(
                        text: "Next",
                        onTap: () async {
                          await _.addProduct(context);
                        },
                      )
                    ]);
              }),
        ),
      ),
    );
  }
}
