import 'package:armar/armar.dart';
import 'package:flags/main/app.dart';
import 'package:flags/ui/debug_paint.dart';
import 'package:flags/uikit/components/progress_indicator/linear_progress_indicator.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:statsfl/statsfl.dart';

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

  runApp(
    const App(),
  );
}
