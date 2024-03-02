import 'package:flutter/cupertino.dart';

import 'images/images.dart';
import 'svg/svg.dart';

abstract class Assets {
  const Assets._();

  static const AssetsSvg svg = AssetsSvg();
  static late AssetsImage images;

  static Future<void> init(BuildContext context) async {
    images = await AssetsImage.initialize();
  }
}
