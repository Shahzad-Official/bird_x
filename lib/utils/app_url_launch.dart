import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUrlLaunch {
  static launchMyUrl(url) async {
    await launchUrl(Uri.parse(url)).then((value) => debugPrint(value.toString())).catchError((err) {});
  }
}
