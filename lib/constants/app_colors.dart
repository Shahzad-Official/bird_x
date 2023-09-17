import 'package:flutter/material.dart';

class AppColors {
  static const primaryColor = Color(0xFFFF842B);
  Map<int, Color> color = const {
    50: Color.fromRGBO(255, 132, 43, .1),
    100: Color.fromRGBO(255, 132, 43, .2),
    200: Color.fromRGBO(255, 132, 43, .3),
    300: Color.fromRGBO(255, 132, 43, .4),
    400: Color.fromRGBO(255, 132, 43, .5),
    500: Color.fromRGBO(255, 132, 43, .6),
    600: Color.fromRGBO(255, 132, 43, .7),
    700: Color.fromRGBO(255, 132, 43, .8),
    800: Color.fromRGBO(255, 132, 43, .9),
    900: Color.fromRGBO(255, 132, 43, 1),
  };
  MaterialColor get customMaterialColor => MaterialColor(0xFFE91E63, color);
}
