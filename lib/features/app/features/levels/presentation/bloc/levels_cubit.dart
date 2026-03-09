import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/features/app/domain/models/game/game_mode_data.dart';
import 'package:flags/features/debug/debug_tools.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class GameLevelsCubit extends Cubit<GameModeProgressData> {
  final SharedPreferences _prefs;
  final GameProcessType gameMode;
  late final StreamSubscription<void> _debugRefreshSubscription;

  GameLevelsCubit(this._prefs, {required this.gameMode})
    : super(GameModeProgressData(gameMode, const {})) {
    _emitStoredState();
    _debugRefreshSubscription = DebugTools.levelsRefreshStream.listen((_) {
      _emitStoredState();
    });
  }

  void _emitStoredState() {
    final data = GameModeProgressData.load(gameMode, _prefs);
    emit(data ?? GameModeProgressData(gameMode, const {}));
  }

  Future<void> saveProgress({
    required ContinentType continent,
    required int levelId,
    required LevelProcessData levelData,
  }) async {
    final state = this.state.copyWith(
      data: {
        ...this.state.data,
        continent: {...this.state.data[continent] ?? {}, '$levelId': levelData},
      },
    );
    await GameModeProgressData.saveData(state, _prefs);
    emit(state);
  }

  int getContinentCompletedLevels(ContinentType continent) {
    return state.data[continent]?.values
            .where((element) => element.completed)
            .length ??
        0;
  }

  LevelProcessData? getLevelData(ContinentType continent, int levelId) {
    return state.data[continent]?['$levelId'];
  }

  Future<void> saveLevel({
    required ContinentType continent,
    required int id,
    required LevelProcessData data,
  }) async {
    final state = this.state.copyWith(
      data: {
        ...this.state.data,
        continent: {...this.state.data[continent] ?? {}, '$id': data},
      },
    );
    await GameModeProgressData.saveData(state, _prefs);
    emit(state);
  }

  @override
  Future<void> close() async {
    await _debugRefreshSubscription.cancel();
    return super.close();
  }
}
