import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/logger.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

class GameModeProgressData extends Equatable {
  final GameProcessType gameMode;
  final Map<ContinentType, Map<String, LevelProcessData>> data;

  const GameModeProgressData(this.gameMode, this.data);

  static GameModeProgressData? load(
      GameProcessType gameMode, SharedPreferences prefs) {
    final jsonData = prefs.getString('gp${gameMode.index}');

    if (jsonData == null) {
      return null;
    }

    try {
      final decoded = jsonDecode(jsonData) as Map<String, dynamic>;
      final resultData = <ContinentType, Map<String, LevelProcessData>>{};

      decoded.forEach((continentKey, levelsData) {
        final continent = ContinentType.values.firstWhere((e) => e.index.toString() == continentKey);
        final levels = <String, LevelProcessData>{};
        (levelsData as Map<String, dynamic>).forEach((levelKey, levelData) {
          levels[levelKey] = LevelProcessData.decode(levelData);
        });
        resultData[continent] = levels;
      });

      return GameModeProgressData(gameMode, resultData);
    } catch (e) {
      logger.e("Error loading data: $e");
      return null;
    }
  }

  static Future<void> saveData(
    GameModeProgressData data,
    SharedPreferences prefs,
  ) async {
    final encodedData = data.encode();
    logger.w(encodedData);
    await prefs.setString('gp${data.gameMode.index}',encodedData);
  }

  String encode() {
    final encodedData = data.map(
      (continent, levels) => MapEntry(
        continent.index.toString(),
        levels.map(
          (levelKey, levelData) => MapEntry(
            levelKey,
            levelData.encode(),
          ),
        ),
      ),
    );
    return jsonEncode(encodedData);
  }

  GameModeProgressData copyWith({
    Map<ContinentType, Map<String, LevelProcessData>>? data,
  }) {
    return GameModeProgressData(
      gameMode,
      data ?? this.data,
    );
  }

  @override
  List<Object?> get props => [gameMode, data];
}
