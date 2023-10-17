import 'dart:convert';

import 'package:bird_x/main.dart';
import 'package:bird_x/models/user_model.dart';
import 'package:intl/intl.dart';

class IntlUtils {
  static String formatedPrice({required String price}) {
    LoginModel userData = box.get("userData") == null ? LoginModel() : LoginModel.fromJson(jsonDecode(box.get("userData")));
    String countryIso = userData.country == null || userData.country!.currencyCode == null ? "PKR" : userData.country!.currencyCode!;
    String symbol = NumberFormat().simpleCurrencySymbol(countryIso);
    var format = NumberFormat();
    return "$symbol ${format.format(double.parse(price))}";
  }

  static String capitalizeEachWord(String sentence) {
    List<String> words = sentence.split(" ");
    if (words.isNotEmpty) {
      for (int i = 0; i < words.length; i++) {
        if (words[i].isNotEmpty) {
          words[i] = "${words[i][0].toUpperCase()}${words[i].substring(1)}";
        }
      }
    }

    return words.join(" ");
  }
}
