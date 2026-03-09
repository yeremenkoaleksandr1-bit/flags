import 'dart:async';

import 'package:flags/domain/domain.dart';
import 'package:flags/features/app/domain/models/game/game_mode_data.dart';
import 'package:flags/prefabs/levels/levels.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

final class DebugTools {
  DebugTools._();

  static final StreamController<void> _levelsRefreshController =
      StreamController<void>.broadcast();

  static Stream<void> get levelsRefreshStream =>
      _levelsRefreshController.stream;

  static Future<void> unlockAllLevels(SharedPreferences prefs) async {
    for (final gameMode in GameProcessType.values) {
      final currentState =
          GameModeProgressData.load(gameMode, prefs) ??
          GameModeProgressData(gameMode, const {});
      final nextData = <ContinentType, Map<String, LevelProcessData>>{
        for (final entry in currentState.data.entries)
          entry.key: Map<String, LevelProcessData>.from(entry.value),
      };

      for (final continentEntry in FactoryGameContinent.continents.entries) {
        final continentData = Map<String, LevelProcessData>.from(
          nextData[continentEntry.key] ?? const <String, LevelProcessData>{},
        );

        for (final level in continentEntry.value.levels) {
          final existingLevelData = continentData['${level.id}'];
          continentData['${level.id}'] = LevelProcessData(
            completed: true,
            seed: existingLevelData?.seed ?? level.id,
          );
        }

        nextData[continentEntry.key] = continentData;
      }

      await GameModeProgressData.saveData(
        GameModeProgressData(gameMode, nextData),
        prefs,
      );
    }

    _levelsRefreshController.add(null);
  }
}
