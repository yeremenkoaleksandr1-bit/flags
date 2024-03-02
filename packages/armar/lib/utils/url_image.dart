import 'package:flutter/services.dart';

abstract class UrlImage {
  static Future<Uint8List> loadNetworkImageBytes(String url) async =>
      (await NetworkAssetBundle(Uri.parse(url)).load(url)).buffer.asUint8List();
}
