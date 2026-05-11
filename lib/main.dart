import 'dart:io';

import 'package:flags/app/app_bootstrap.dart';
import 'package:flags/features/app/presentation/application.dart';
import 'package:flags/uikit/components/progress_indicator/linear_progress_indicator.dart';
import 'package:flags/uikit/shaders/shaders.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  await Flame.device.setPortraitUpOnly();
  await dotenv.load(fileName: '.env');
  await GameShaders.init();


  await MobileAds.instance.initialize();

  EasyLoading.instance
    ..maskType = EasyLoadingMaskType.custom
    ..maskColor = ThemePalette.black.withValues(alpha: 0.6)
    ..loadingStyle = EasyLoadingStyle.custom
    ..animationStyle = EasyLoadingAnimationStyle.opacity
    ..backgroundColor = ThemePalette.transparent
    ..boxShadow = <BoxShadow>[]
    ..indicatorColor = ThemePalette.white
    ..textColor = ThemePalette.white
    ..dismissOnTap = false
    ..indicatorWidget = Builder(
      builder: (context) {
        return const Column(
          children: [_LoadingLabel(), FLinearProgressIndicator()],
        );
      },
    );

  final bootstrap = await AppBootstrap.initialize();

  runApp(Application(bootstrap: bootstrap));
}

class _LoadingLabel extends StatelessWidget {
  const _LoadingLabel();

  @override
  Widget build(BuildContext context) {
    return FText("loading");
  }
}
