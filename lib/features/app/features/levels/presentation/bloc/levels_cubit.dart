import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/features/app/domain/models/game/game_mode_data.dart';
import 'package:meta/meta.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class GameLevelsCubit extends Cubit<GameModeProgressData> {
  final SharedPreferences _prefs;
  final GameProcessType gameMode;

  GameLevelsCubit(
    this._prefs, {
    required this.gameMode,
  }) : super(
          GameModeProgressData(
            gameMode,
            const {},
          ),
        ) {
    final GameModeProgressData? data =
        GameModeProgressData.load(gameMode, _prefs);

    if (data != null) {
      emit(data);
    }
  }

  Future<void> saveProgress({
    required ContinentType continent,
    required int levelId,
    required LevelProcessData levelData,
  }) async {
    final state = this.state.copyWith(
      data: {
        ...this.state.data,
        continent: {
          ...this.state.data[continent] ?? {},
          '$levelId': levelData,
        },
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
        continent: {
          ...this.state.data[continent] ?? {},
          '$id': data,
        },
      },
    );
    await GameModeProgressData.saveData(state, _prefs);
    emit(state);
  }
}
