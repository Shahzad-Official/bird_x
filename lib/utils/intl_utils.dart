import 'dart:convert';

import 'package:bird_x/main.dart';
import 'package:bird_x/models/user_model.dart';
import 'package:intl/intl.dart';

class IntlUtils {
  static String formatedPrice({required String price}) {
    LoginModel userData = LoginModel.fromJson(jsonDecode(box.get("userData")));
    String countryIso = userData.country == null || userData.country!.currencyCode == null ? "PKR" : userData.country!.currencyCode!;
    String symbol = NumberFormat().simpleCurrencySymbol(countryIso);
    var format = NumberFormat.compact();
    return "$symbol ${format.format(double.parse(price))}";
  }
}
