// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:state_manager/state_manager.dart';
import 'package:flags/core/flutter_engine.dart';
import 'package:flags/domain/adapters.dart';
import 'package:flags/domain/preferences/preferences.dart';
import 'package:flags/domain/services/game/emblems.service.dart';
import 'package:flags/domain/services/levels/levels.service.dart';
import 'package:flags/features/onboarding/onboarding.service.dart';
import 'package:flags/main/components/splash.dart';
import 'package:flags/presentation/app/state/app.state.dart';
import 'package:flags/presentation/navigator/router.dart';
import 'package:flags/resources/resources.dart';
import 'package:flags/uikit/assets/assets.dart';
import 'package:flags/uikit/shaders/shaders.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qlevar_router/qlevar_router.dart';

abstract interface class IAppPresenter with StateMixin<IAppState> {
  static IAppPresenter get I => Get.find<IAppPresenter>(tag: "app");

  static bool get isDebugMode => I.appPreferences.data.isDebugMode;

  ILevelsService get levelsService;

  IEmblemsService get emblemsService;

  AppPreferences get appPreferences;

  GamePreferences get gameState;

  AppRouter get router;
}

class AppPresenterImpl extends GetxController
    with StateMixin<IAppState>, GetSingleTickerProviderStateMixin
    implements IAppPresenter {
  @override
  late final ILevelsService levelsService;

  @override
  late final IEmblemsService emblemsService;

  @override
  late final AppPreferences appPreferences;
  @override
  late final GamePreferences gameState;

  final BuildContext context;

  @override
  late final AppRouter router;

  AppPresenterImpl({required this.context});

  @override
  Future<void> onInit() async {
    final Completer<dynamic> endSplashAnimationCompleter = Completer();

    AnimationController? splashAnimator;
    final OverlayEntry splashOverlayEntry = OverlayEntry(
      builder: (_) => const Splash().animate(
        onInit: (controller) => splashAnimator = controller,
        onComplete: (c) {
          endSplashAnimationCompleter.complete();
        },
        autoPlay: false,
        effects: [
          const FadeEffect(
            begin: 1,
            end: 0,
          ),
          const MoveEffect(
            duration: Duration(milliseconds: 1500),
            begin: Offset.zero,
            end: Offset(0, 300),
          ),
        ],
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Overlay.of(context).insert(splashOverlayEntry);
    });

    change(
      GetStatus.success(
        InitializingAppState(),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    Hive.defaultDirectory = dir.path;

    registerHiveAdapters();

    await Assets.init(context);

    appPreferences = AppPreferences();
    gameState = GamePreferences();

    final Resources resources = Resources();
    await resources.initialize();

    levelsService = await LevelsServiceImpl().initialize();
    emblemsService = await EmblemsServiceImpl().initialize();

    router = AppRouter();

    Get.put<IOnboardingService>(OnboardingServiceImpl(), permanent: true);

    super.onInit();

    FlutterEngine.schedulePostFrameCallback((timeStamp) {
      QR.replaceAll("/app").whenComplete(() async {
        change(
          GetStatus.success(
            AppState(
              resources: resources,
            ),
          ),
        );

        FlutterEngine.widgetPostFrameCallback((timeStamp) async {
          splashAnimator!.forward(from: 0);
          await endSplashAnimationCompleter.future;
          splashOverlayEntry.remove();
        });
      });
    });
  }

  @override
  void dispose() {
    gameState.dispose();
    super.dispose();
  }
}
