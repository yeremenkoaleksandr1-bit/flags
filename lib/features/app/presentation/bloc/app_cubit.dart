// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:bloc_utils/bloc_utils.dart';
import 'package:flags/core/flutter_engine.dart';
import 'package:flags/domain/preferences/preferences.dart';
import 'package:flags/domain/services/game/emblems.service.dart';
import 'package:flags/domain/services/levels/levels.service.dart';
import 'package:flags/features/app/presentation/bloc/app_state.dart';
import 'package:flags/getIt.dart';
import 'package:flags/main.dart';
import 'package:flags/main/components/splash.dart';
import 'package:flags/navigator/router.gr.dart';
import 'package:flags/resources/resources.dart';
import 'package:flags/services/onboarding/onboarding.service.dart';
import 'package:flags/uikit/assets/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';

abstract interface class IAppCubit extends DynamicStatedCubitStream<AppState> {
  IEmblemsService get emblemsService;

  AppPreferencesCubit get appPreferences;

  GamePreferences get gameState;
}

final class AppCubitImpl extends StatedCubit<AppState> implements IAppCubit {
  @override
  late final IEmblemsService emblemsService;

  @override
  late final AppPreferencesCubit appPreferences;
  @override
  late final GamePreferences gameState;

  final BuildContext context;

  AppCubitImpl({
    required this.context,
  });

  @override
  Future<void> onInit() async {
    final Completer<dynamic> endSplashAnimationCompleter = Completer();

    await Assets.init(context);

    appPreferences = AppPreferencesCubit(
      sharedPreferences,
    );

    gameState = GamePreferences(sharedPreferences);

    final Resources resources = Resources();
    await resources.initialize();

    emblemsService = EmblemsServiceImpl(sharedPreferences);

    getIt.registerSingleton<IOnboardingService>(
      OnboardingServiceImpl(
        prefs: sharedPreferences,
      ),
    );

    emit(
      SuccessState(
        AppState(resources: resources),
      ),
    );

    super.onInit();
  }
}

class ConsolidatedObserver extends NavigatorObserver {
  final List<NavigatorObserver> observers;

  ConsolidatedObserver(this.observers);

  @override
  void didPush(Route route, Route? previousRoute) {
    for (final observer in observers) {
      observer.didPush(route, previousRoute);
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    for (final observer in observers) {
      observer.didPop(route, previousRoute);
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    for (final observer in observers) {
      observer.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    }
  }
}
