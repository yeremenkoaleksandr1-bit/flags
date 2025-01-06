import 'dart:convert';

import 'package:flags/domain/domain.dart';
import 'package:flags/prefabs/levels/levels.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

abstract interface class ILevelsService {
  LevelModel? getLevelData({
    required int levelId,
    required ContinentType continent,
    required GameProcessType gameMode,
  });

  void saveLevel({
    required int levelId,
    required bool completed,
    required ContinentType continent,
    required GameProcessType gameMode,
    int seed = 1,
  });

  int getCompletedLevelsCount();
}

class LevelsServiceImpl implements ILevelsService {
  final SharedPreferences _preferences;

  LevelsServiceImpl(this._preferences) {
    final isLevelsInitialized =
        _preferences.getBool('levels_initialized') ?? false;

    if (!isLevelsInitialized) {
      final savedData = _preferences.getString('levels_progress') ?? '{}';
      final initData = jsonDecode(savedData) as Map<String, dynamic>;

      _initializeLevels(initData);

      _preferences.setString('levels_progress', jsonEncode(initData));
      _preferences.setBool('levels_initialized', true);
    }
  }

  @override
  void saveLevel({
    required int levelId,
    required bool completed,
    required ContinentType continent,
    required GameProcessType gameMode,
    int seed = -1,
  }) {
    final model = LevelModel(
      id: levelId,
      completed: completed,
      seed: seed,
    );

    final key = "${gameMode.index}_${continent.index}_$levelId";

    _preferences.setString(
      'levels_progress',
      jsonEncode(
        {
          ...jsonDecode(_preferences.getString('levels_progress') ?? '{}'),
          key: model.toJson(),
        },
      ),
    );
  }

  @override
  LevelModel? getLevelData({
    required int levelId,
    required ContinentType continent,
    required GameProcessType gameMode,
  }) {
    final key = "${gameMode.index}_${continent.index}_$levelId";

    final data = jsonDecode(_preferences.getString('levels_progress') ?? '{}');

    final levelData = data[key];

    if (levelData == null) {
      return null;
    }

    return LevelModel.fromJson(levelData);
  }

  void _initializeLevels(Map<String, dynamic> initData) {
    const gameModes = GameProcessType.values;
    final continents = FactoryGameContinent.continents;

    for (final mode in gameModes) {
      for (final continent in continents.entries) {
        final keyPrefix = "${mode.name}_${continent.value.name}_";

        for (final level in continent.value.levels) {
          final key = "$keyPrefix${level.id}";
          if (!initData.containsKey(key)) {
            initData[key] = LevelModel(
              id: level.id,
              completed: false,
              seed: -1,
            ).toJson();
          }
        }
      }
    }
  }

  @override
  int getCompletedLevelsCount() {
    final data = jsonDecode(_preferences.getString('levels_progress') ?? '{}');
    return data.values
        .whereType<Map<String, dynamic>>()
        .where((element) => element['completed'] == true)
        .length;
  }
}
