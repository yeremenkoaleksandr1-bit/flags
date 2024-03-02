import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class ArLaunchInApp {
  static Future<void> launchInApp(String url) async {
    EasyLoading.show();
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
    EasyLoading.dismiss();
  }

  static Future<void> launchEmail(String email) async {
    await launchInApp("mailto:$email");
  }

  static Future<void> launchPhoneNumber(String number) =>
      launchInApp("tel://$number");

  static Future<void> launchInGooglePlay(String appId) =>
      launchInApp("market://details?id=$appId");

  static Future<void> launchInYT(String videoId) =>
      launchInApp("https://www.youtube.com/watch?v=$videoId}");

// TODO: implement open in app store
}
