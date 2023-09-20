import 'package:bird_x/constants/app_spacing.dart';
import 'package:bird_x/utils/app_navigation.dart';
import 'package:bird_x/views/chat_screens/chat_screen.dart';
import 'package:bird_x/views/notifications.dart/notifications.dart';
import 'package:bird_x/widgets/app_shadowcontainer.dart';
import 'package:bird_x/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ChatsView extends StatelessWidget {
  ChatsView({Key? key}) : super(key: key);
  final List<String> imageUrls = [
    "https://images.unsplash.com/photo-1511367461989-f85a21fda167?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cHJvZmlsZXxlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80",
    "https://assets.website-files.com/619e8d2e8bd4838a9340a810/647c106477f8934b266ba39c_profile-picture-og.webp",
    "https://image.winudf.com/v2/image1/bmV0LndsbHBwci5ib3lzX3Byb2ZpbGVfcGljdHVyZXNfc2NyZWVuXzBfMTY2NzUzNzYxN18wOTk/screen-0.webp?fakeurl=1&type=.webp",
  ];
  final List<String> names = ["Gloria", "John", "Alice"];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Flexible(
                    flex: 9,
                    child: AppText(
                      text: "Chats",
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    )),
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
      body: Padding(
        padding: AppSpacing.defaultPadding,
        child: Column(
          children: [
            AppSpacing.heigthSpace20,
            ListView.builder(
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  final imageUrl = imageUrls[index];
                  final name = names[index];

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: InkWell(
                      onTap: () {
                        AppNavigation.to(context,
                            nextPage: ChatScreen(
                              name: name,
                            ));
                      },
                      child: Container(
                        height: 52,
                        width: double.infinity,
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.circular(30),
                                child: Image.network(
                                  imageUrl,
                                  height: 52,
                                  width: 52,
                                  fit: BoxFit.cover,
                                )),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  text: name,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w500,
                                ),
                                const AppText(
                                  text: "Sup Dude?😅",
                                  fontSize: 15,
                                ),
                              ],
                            ),
                            const Spacer(),
                            const AppText(
                              text: "14:33",
                              color: Color(0xff5F5F5F),
                              fontSize: 12,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
