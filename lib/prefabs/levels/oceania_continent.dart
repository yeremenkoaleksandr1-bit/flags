import '../../domain/domain.dart';
import '../../domain/entities/game/game.dart';
import '../../domain/entities/game/game_levels/game_level.dart';
import '../flags/oceania.dart';

class OceaniaContinent extends GameLevels {
  OceaniaContinent()
      : super(
          name: "Oceania",
          type: ContinentType.oceania,
          sections: <GameLevelsSection>[
            GameLevelsSection(
              name: "easy",
              difficulty: GameDifficult.easy,
              levels: [
                GameLevel(flag: PalauFlag(), opened: true),
                GameLevel(flag: FederatedStatesOfMicronesiaFlag()),
                GameLevel(flag: NorthernMarianaIslandsFlag()),
                GameLevel(flag: GuamFlag()),
                GameLevel(flag: NorfolkIslandFlag()),
                GameLevel(flag: NiueFlag()),
                GameLevel(flag: TongaFlag()),
                GameLevel(flag: AustraliaFlag()),
                GameLevel(flag: NewZealandFlag()),
              ],
            ),
            GameLevelsSection(
              name: "medium",
              difficulty: GameDifficult.medium,
              levels: [
                GameLevel(flag: FijiFlag()),
                GameLevel(flag: SamoaFlag()),
                GameLevel(flag: TuvaluFlag()),
                GameLevel(flag: FrenchPolynesiaFlag()),
                GameLevel(flag: AmericanSamoaFlag()),
                GameLevel(flag: PitcairnIslandsFlag()),
                GameLevel(flag: CookIslandsFlag()),
              ],
            ),
            GameLevelsSection(
              name: "hard",
              difficulty: GameDifficult.hard,
              levels: [
                GameLevel(flag: PapuaNewGuineaFlag()),
                GameLevel(flag: KiribatiFlag()),
                GameLevel(flag: SolomonIslandFlag()),
                GameLevel(flag: MarshallIslandsFlag()),
                GameLevel(flag: NewCaledoniaFlag()),
                GameLevel(flag: WallisAndFutunaFlag()),
                GameLevel(flag: NauruFlag()),
                GameLevel(flag: VanuatuFlag()),
              ],
            ),
          ],
        );
}
