// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:armar/armar.dart';
import 'package:armar/logger.dart';
import 'package:flags/core/flutter_engine.dart';
import 'package:flags/domain/services/levels/levels.service.dart';
import 'package:flags/presentation/app/state/app.state.dart';
import 'package:flags/resources/resources.dart';
import 'package:flags/ui/builders/app/components/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../domain/adapters.dart';
import '../../domain/preferences/preferences.dart';
import '../../domain/services/game/emblems.service.dart';
import '../../uikit/assets/assets.dart';
import '../navigator/router.dart';

abstract interface class IAppPresenter with StateMixin<IAppState> {
  static IAppPresenter get i => Get.find<IAppPresenter>(tag: "app");

  ILevelsService get levelsService;

  IEmblemsService get emblemsService;

  AppPreferences get appPreferences;

  GamePreferences get gamePreferences;

  AppRouter get router;
}

class AppPresenterImpl extends GetxController
    with StateMixin<IAppState>
    implements IAppPresenter {
  @override
  late final ILevelsService levelsService;

  @override
  late final IEmblemsService emblemsService;

  @override
  late final AppPreferences appPreferences;
  @override
  late final GamePreferences gamePreferences;

  final BuildContext context;

  @override
  late final AppRouter router;

  AppPresenterImpl({required this.context});

  @override
  void onInit() async {
    Completer endSplashAnimationCompleter = Completer();
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
    gamePreferences = GamePreferences();

    final Resources resources = Resources();
    await resources.initialize();

    levelsService = await LevelsServiceImpl().initialize();
    emblemsService = await EmblemsServiceImpl().initialize();

    router = AppRouter();

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
}
