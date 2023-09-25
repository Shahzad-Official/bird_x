import 'package:intl/intl.dart';

class AppDateUtils {
  static String formatDate({
    required String pattern,
    required String date,
  }) {
    DateTime dateTime = DateTime.parse(date).toLocal();
    return DateFormat(pattern).format(dateTime);
  }
}
