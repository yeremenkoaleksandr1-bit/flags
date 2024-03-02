import 'package:flags/domain/domain.dart';
import 'package:flags/domain/entities/game/game.dart';

import 'game_level.dart';

class GameLevels {
  final String name;
  final ContinentType type;
  final List<GameLevelsSection> sections;

  List<GameLevel> get levels => sections.expand((e) => e.levels).toList();

  GameLevels({
    required this.name,
    required this.type,
    required this.sections,
  }) {
    levels.asMap().forEach(
          (key, value) => value.id = key,
        );
  }
}
