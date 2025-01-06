import 'package:flags/features/app/presentation/application.dart';
import 'package:flags/main/app.dart';
import 'package:flags/shared/data/local/secure_storage.dart';
import 'package:flags/shared/data/local/shared_preferences_storage.dart';
import 'package:flags/uikit/components/progress_indicator/linear_progress_indicator.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

late final SharedPreferences sharedPreferences;

void main() async {
  final WidgetsBinding binding = WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: [],
  );

  await Flame.device.setPortraitUpOnly();

  EasyLoading.instance
    ..maskType = EasyLoadingMaskType.custom
    ..maskColor = ThemePalette.black.withOpacity(0.6)
    ..loadingStyle = EasyLoadingStyle.custom
    ..animationStyle = EasyLoadingAnimationStyle.opacity
    ..backgroundColor = ThemePalette.transparent
    ..boxShadow = <BoxShadow>[]
    ..indicatorColor = ThemePalette.white
    ..textColor = ThemePalette.white
    ..dismissOnTap = false
    ..indicatorWidget = Column(
      children: [
        FText("loading"),
        const FLinearProgressIndicator(),
      ],
    );

  await SecureStorageServiceImpl().init();
  sharedPreferences = await SharedPreferences.getInstance();


  runApp(
    const Application(),
  );
}
