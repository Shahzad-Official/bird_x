import 'package:intl/intl.dart';

class IntlUtils {
  static String formatedPrice({String countryIso = "PKR", required String price}) {
    String symbol = NumberFormat().simpleCurrencySymbol(countryIso);
    var format = NumberFormat.compact();
    return "$symbol ${format.format(double.parse(price))}";
  }
}
