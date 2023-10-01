import 'package:bird_x/constants/app_colors.dart';
import 'package:bird_x/constants/app_spacing.dart';
import 'package:bird_x/models/all_product_model.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/views/main_page_views/menu_views/categories_home.dart';
import 'package:bird_x/views/main_page_views/menu_views/prdouct_details.dart';
import 'package:bird_x/widgets/app_field.dart';
import 'package:bird_x/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class WishlistView extends StatefulWidget {
  const WishlistView({Key? key}) : super(key: key);

  @override
  State<WishlistView> createState() => _WishlistViewState();
}

class _WishlistViewState extends State<WishlistView> {
  final List<String> imageUrls = [
    "https://b1157417.smushcdn.com/1157417/wp-content/uploads/fish-discus-swimming-825x550.jpg?lossy=1&strip=1&webp=0",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcR7bjwX3Gucn1jzP_7sIb82UzeiBLDhDZXnyg&usqp=CAU",
    "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT_NZukTmUyMB5GKl19VWQGdyRtksWj4Qh51w&usqp=CAU",
    "https://w7.pngwing.com/pngs/862/145/png-transparent-chicken-as-food-broiler-poultry-hen-chicken-thumbnail.png"
  ];
  final List<String> namesPets = ["Fish", "Pigeon", "1 Pair of Cat", "Hen"];
  final List<String> pricePets = ["Rs 5,000", "Rs  200", "Rs 20000", "Rs 8,000"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const AppText(
          text: "WishList",
        ),
      ),
      body: SingleChildScrollView(
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
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 4, mainAxisSpacing: 4, mainAxisExtent: 250),
                itemBuilder: (BuildContext context, int index) {
                  final imageUrl = imageUrls[index];
                  final name = namesPets[index];
                  final price = pricePets[index];

                  return InkWell(
                    onTap: () {
                      AppNavigation.to(
                        context,
                        nextPage: ProductDetails(
                          productData: ProductData(),
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
                                child: Image.network(
                                  imageUrl,
                                  height: 180,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 5, top: 3),
                                child: Icon(
                                  Icons.favorite,
                                  color: AppColors.primaryColor,
                                ),
                              )
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
  }
}
