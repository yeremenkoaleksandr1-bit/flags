import 'package:flags/domain/entities/game/game.dart';

import '../../domain/domain.dart';
import '../../domain/entities/game/game_levels/game_level.dart';
import '../flags/asia.dart';
import '../flags/europe.dart';

class EuropeContinent extends GameLevels {
  EuropeContinent()
      : super(
          name: 'Europe',
          type: ContinentType.europe,
          sections: <GameLevelsSection>[
            GameLevelsSection(
              name: "super easy",
              difficulty: GameDifficult.superEasy,
              levels: [
                GameLevel(flag: PolandFlag(), opened: true),
                GameLevel(flag: AlbaniaFlag()),
                GameLevel(flag: SwitzerlandFlag()),
                GameLevel(flag: UkraineFlag()),
                GameLevel(flag: MonacoFlag()),
                GameLevel(flag: FinlandFlag()),
                GameLevel(flag: SwedenFlag()),
                GameLevel(flag: DenmarkFlag()),
              ],
            ),
            GameLevelsSection(
              name: "easy",
              difficulty: GameDifficult.easy,
              levels: [
                GameLevel(flag: LatviaFlag()),
                GameLevel(flag: IrelandFlag()),
                GameLevel(flag: RomaniaFlag()),
                GameLevel(flag: FranceFlag()),
                GameLevel(flag: ItalyFlag()),
                GameLevel(flag: BelgiumFlag()),
                GameLevel(flag: RussiaFlag()),
              ],
            ),
            GameLevelsSection(
              name: "medium",
              difficulty: GameDifficult.medium,
              levels: [
                GameLevel(flag: LithuaniaFlag()),
                GameLevel(flag: EstoniaFlag()),
                GameLevel(flag: LuxembourgFlag()),
                GameLevel(flag: GermanyFlag()),
                GameLevel(flag: BulgariaFlag()),
                GameLevel(flag: HungaryFlag()),
                GameLevel(flag: ArmeniaFlag()),
                GameLevel(flag: NorwayFlag()),
                GameLevel(flag: IcelandFlag()),
                GameLevel(flag: CzechFlag()),
              ],
            ),
            GameLevelsSection(
              name: "hard",
              difficulty: GameDifficult.hard,
              levels: [
                GameLevel(flag: SanMarinoFlag()),
                GameLevel(flag: VaticanCityFlag()),
                GameLevel(flag: MontenegroFlag()),
                GameLevel(flag: AndorraFlag()),
                GameLevel(flag: SerbiaFlag()),
                GameLevel(flag: SpainFlag()),
                GameLevel(flag: SlovakiaFlag()),
                GameLevel(flag: PortugalFlag()),
                GameLevel(flag: AzerbaijanFlag()),
                GameLevel(flag: CroatiaFlag()),
                GameLevel(flag: MoldovaFlag()),
                GameLevel(flag: BelarusFlag()),
              ],
            ),
            GameLevelsSection(
              name: "extra hard",
              difficulty: GameDifficult.extraHard,
              levels: [
                GameLevel(flag: BosniaAndHerzegovinaFlag()),
                GameLevel(flag: CyprusFlag()),
                GameLevel(flag: GeorgiaFlag()),
                GameLevel(flag: NorthMacedoniaFlag()),
                GameLevel(flag: UnitedKingdomFlag()),
                GameLevel(flag: GreeceFlag()),
                GameLevel(flag: KazakhstanFlag()),
                GameLevel(flag: MaltaFlag()),
                GameLevel(flag: SloveniaFlag()),
                GameLevel(flag: TurkeyFlag()),
                GameLevel(flag: LiechtensteinFlag()),
              ],
            ),
          ],
        );
}
