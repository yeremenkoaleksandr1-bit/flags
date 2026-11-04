import '../../domain/domain.dart';
import '../../domain/entities/game/game.dart';
import '../../domain/entities/game/game_levels/game_level.dart';
import '../flags/south_america.dart';

class SouthAmericaContinent extends GameContinentData {
  SouthAmericaContinent()
      : super(
          name: "South America",
          sections: <GameLevelsSection>[
            GameLevelsSection(
              name: "easy",
              difficulty: GameDifficult.easy,
              levels: [
                GameLevel(flag: ArgentinaFlag(), opened: true),
                GameLevel(flag: BrazilFlag()),
                GameLevel(flag: PeruFlag()),
                GameLevel(flag: ChileFlag()),
                GameLevel(flag: UruguayFlag()),
              ],
            ),
            GameLevelsSection(
              name: "medium",
              difficulty: GameDifficult.medium,
              levels: [
                GameLevel(flag: BoliviaFlag(), opened: true),
                GameLevel(flag: VenezuelaFlag()),
                GameLevel(flag: GuyanaFlag()),
                GameLevel(flag: SurinameFlag()),
                GameLevel(flag: ParaguayFlag()),
                GameLevel(flag: EcuadorFlag()),
              ],
            ),
          ],
        );
}
