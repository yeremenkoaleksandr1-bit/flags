import 'package:flags/domain/entities/game/game.dart';

import 'game_level.dart';

class GameContinentData {
  final String name;
  final List<GameLevelsSection> sections;

  List<GameLevel> get levels => sections.expand((e) => e.levels).toList();

  GameContinentData({
    required this.name,
    required this.sections,
  }) {
    levels.asMap().forEach(
          (key, value) => value.id = key,
        );
  }

  GameContinentData clone() {
    return GameContinentData(
      name: name,
      sections: [
        ...sections.map(
          (e) => e.clone(),
        ),
      ],
    );
  }
}
