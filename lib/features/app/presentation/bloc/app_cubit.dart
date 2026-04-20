// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:bloc_utils/bloc_utils.dart';
import 'package:flags/domain/preferences/preferences.dart';
import 'package:flags/domain/services/game/emblems.service.dart';
import 'package:flags/features/app/presentation/bloc/app_state.dart';
import 'package:flags/resources/resources.dart';
import 'package:flags/uikit/assets/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class IAppCubit extends DynamicStatedBlocStream<AppState> {
  IEmblemsService get emblemsService;

  AppPreferencesCubit get preferences;

}

final class AppCubitImpl extends StatedCubit<AppState> implements IAppCubit {
  @override
  late final IEmblemsService emblemsService;

  @override
  late final AppPreferencesCubit preferences;


  final BuildContext context;
  final SharedPreferences sharedPreferences;

  AppCubitImpl({
    required this.context,
    required this.sharedPreferences,
  });

  @override
  Future<void> onInit() async {
    await Assets.init(context);

    preferences = AppPreferencesCubit(sharedPreferences);
    preferences.setDebugMode(true);

    final Resources resources = Resources();
    await resources.initialize();

    emblemsService = EmblemsServiceImpl(sharedPreferences);

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
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    for (final observer in observers) {
      observer.didPush(route, previousRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    for (final observer in observers) {
      observer.didPop(route, previousRoute);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    for (final observer in observers) {
      observer.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    }
  }
}
