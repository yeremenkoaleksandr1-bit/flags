// ignore_for_file: use_build_context_synchronously

import 'package:armar/armar.dart';
import 'package:flags/domain/services/levels/levels.service.dart';
import 'package:flags/presentation/app/state/app.state.dart';
import 'package:flags/resources/resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

import '../../domain/adapters.dart';
import '../../domain/preferences/preferences.dart';
import '../../domain/services/game/emblems.service.dart';
import '../../uikit/assets/assets.dart';

abstract interface class IAppPresenter with StateMixin<IAppState> {
  static IAppPresenter get i => Get.find<IAppPresenter>(tag: "app");

  ILevelsService get levelsService;

  IEmblemsService get emblemsService;

  AppPreferences get appPreferences;

  GamePreferences get gamePreferences;
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

  AppPresenterImpl({required this.context}) {
    change(
      GetStatus.success(
        InitializingAppState(),
      ),
    );
  }

  @override
  void onInit() async {
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

    change(
      GetStatus.success(
        AppState(
          resources: resources,
        ),
      ),
    );

    super.onInit();
  }
}
