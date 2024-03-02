import '../../domain/domain.dart';
import '../../domain/entities/game/game.dart';
import '../../domain/entities/game/game_levels/game_level.dart';
import '../flags/north_america.dart';

class NorthAmericaContinent extends GameLevels {
  NorthAmericaContinent()
      : super(
          name: "North America",
          type: ContinentType.northAmerica,
          sections: <GameLevelsSection>[
            GameLevelsSection(
              name: "easy",
              difficulty: GameDifficult.easy,
              levels: [
                GameLevel(flag: CanadaFlag(), opened: true),
                GameLevel(flag: UnitedStatesFlag()),
                GameLevel(flag: MexicoFlag()),
                GameLevel(flag: HaitiFlag()),
                GameLevel(flag: SaintLuciaFlag()),
                GameLevel(flag: TrinidadAndTobagoFlag()),
              ],
            ),
            GameLevelsSection(
              name: "medium",
              difficulty: GameDifficult.medium,
              levels: [
                GameLevel(flag: BahamasFlag(), opened: true),
                GameLevel(flag: BarbadosFlag()),
                GameLevel(flag: BelizeFlag()),
                GameLevel(flag: GuatemalaFlag()),
                GameLevel(flag: HondurasFlag()),
                GameLevel(flag: NicaraguaFlag()),
                GameLevel(flag: SalvadorFlag()),
                GameLevel(flag: SaintVincentAndTheGrenadinesFlag()),
              ],
            ),
            GameLevelsSection(
              name: "hard",
              difficulty: GameDifficult.hard,
              levels: [
                GameLevel(flag: AntiguaAndBarbudaFlag(), opened: true),
                GameLevel(flag: GrenadaFlag()),
                GameLevel(flag: DominicaFlag()),
                GameLevel(flag: DominicanRepublicFlag()),
                GameLevel(flag: CostaRicaFlag()),
                GameLevel(flag: CubaFlag()),
                GameLevel(flag: PanamaFlag()),
                GameLevel(flag: SaintKittsAndNevisFlag()),
                GameLevel(flag: JamaicaFlag()),
              ],
            ),
          ],
        );
}
