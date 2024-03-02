import 'package:flags/domain/domain.dart';

import 'game_level.dart';

class GameLevelsSection {
  final String name;
  final List<GameLevel> levels;
  final GameDifficult difficulty;

  GameLevelsSection({
    required this.name,
    required this.levels,
    required this.difficulty,
  });

  GameLevelsSection clone() {
    return GameLevelsSection(
      name: name,
      levels: [
        ...levels.map(
          (e) => e.clone(),
        )
      ],
      difficulty: difficulty,
    );
  }
}
