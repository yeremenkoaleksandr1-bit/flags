import '../../domain/domain.dart';
import '../../domain/entities/game/game.dart';

class WholeWorldContinent extends GameLevels {
  WholeWorldContinent()
      : super(
          name: "Whole World",
          type: ContinentType.oceania,
          sections: <GameLevelsSection>[],
        );
}
