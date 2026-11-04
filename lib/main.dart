import 'dart:async';
import 'dart:ui';

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
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('FlutterError: ${details.exceptionAsString()}');
  };
  PlatformDispatcher.instance.onError = (error, stackTrace) {
    debugPrint('Uncaught error: $error\n$stackTrace');
    return true;
  };

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  // Any step failing here used to abort main() before runApp(), leaving the
  // native splash on screen forever (seen on Android 8/9 and BlueStacks).
  // Each step is now isolated so the app always reaches runApp().
  await _guard('orientation', Flame.device.setPortraitUpOnly);
  await _guard('dotenv', () => dotenv.load());
  await _guard('shaders', GameShaders.init);

  // Ads must never block startup: initialize in the background.
  if (!kIsWeb) {
    unawaited(
      _guard(
        'ads',
        () => MobileAds.instance.initialize(),
        timeout: const Duration(seconds: 30),
      ),
    );
  }

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

Future<void> _guard(
  String name,
  Future<Object?> Function() action, {
  Duration timeout = const Duration(seconds: 10),
}) async {
  try {
    await action().timeout(timeout);
  } catch (error, stackTrace) {
    debugPrint('Startup step "$name" failed: $error\n$stackTrace');
  }
}

class _LoadingLabel extends StatelessWidget {
  const _LoadingLabel();

  @override
  Widget build(BuildContext context) {
    return FText("loading");
  }
}
