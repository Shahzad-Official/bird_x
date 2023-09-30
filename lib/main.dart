import 'package:bird_x/constants/app_colors.dart';
import 'package:bird_x/firebase_options.dart';
import 'package:bird_x/views/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox("data");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

Box box = Hive.box("data");
initDynamicLinks() async {
  final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
  final Uri? link = data?.link;

  if (link != null) {
    String referralCode = link.queryParameters.values.toList().first;
    box.put("referralCode", referralCode);
  }
  FirebaseDynamicLinks.instance.onLink.listen((dynamicLink) {
    Uri? deepLink = dynamicLink.link;
    String referralCode = deepLink.queryParameters.values.toList().first;
    box.put("referralCode", referralCode);
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    initDynamicLinks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BirdX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          centerTitle: true,
          titleTextStyle: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        navigationBarTheme: NavigationBarThemeData(
          indicatorShape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        brightness: Brightness.light,
        primarySwatch: AppColors().customMaterialColor,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
          primary: AppColors.primaryColor,
          secondary: AppColors.primaryColor,
        ),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
