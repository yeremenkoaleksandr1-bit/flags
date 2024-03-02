import '../../domain/domain.dart';
import '../../domain/entities/game/game.dart';
import '../../domain/entities/game/game_levels/game_level.dart';
import '../flags/africa.dart';

class AfricaContinent extends GameLevels {
  AfricaContinent()
      : super(
          name: "Africa",
          type: ContinentType.africa,
          sections: <GameLevelsSection>[
            GameLevelsSection(
              name: "easy",
              difficulty: GameDifficult.easy,
              levels: [
                GameLevel(flag: GabonFlag(), opened: true),
                GameLevel(flag: RepublicOfTheCongoFlag()),
                GameLevel(flag: BeninFlag()),
                GameLevel(flag: IvoryCoastFlag()),
                GameLevel(flag: BotswanaFlag()),
                GameLevel(flag: MadagascarFlag()),
                GameLevel(flag: NigeriaFlag()),
                GameLevel(flag: MaliFlag()),
                GameLevel(flag: SomaliaFlag()),
                GameLevel(flag: SierraLeoneFlag()),
                GameLevel(flag: TunisiaFlag()),
                GameLevel(flag: ChadFlag()),
                GameLevel(flag: MoroccoFlag()),
              ],
            ),
            GameLevelsSection(
              name: "medium",
              difficulty: GameDifficult.medium,
              levels: [
                GameLevel(flag: LibyaFlag()),
                GameLevel(flag: AlgeriaFlag()),
                GameLevel(flag: AngolaFlag()),
                GameLevel(flag: BurkinaFasoFlag()),
                GameLevel(flag: GambiaFlag()),
                GameLevel(flag: GuineaBissauFlag()),
                GameLevel(flag: CameroonFlag()),
                GameLevel(flag: LesothoFlag()),
                GameLevel(flag: MauritaniaFlag()),
                GameLevel(flag: SenegalFlag()),
                GameLevel(flag: SudanFlag()),
                GameLevel(flag: EthiopiaFlag()),
                GameLevel(flag: EgyptFlag()),
                GameLevel(flag: NigerFlag()),
              ],
            ),
            GameLevelsSection(
              name: "hard",
              difficulty: GameDifficult.hard,
              levels: [
                GameLevel(flag: DjiboutiFlag()),
                GameLevel(flag: ZambiaFlag()),
                GameLevel(flag: KenyaFlag()),
                GameLevel(flag: LiberiaFlag()),
                GameLevel(flag: MauritiusFlag()),
                GameLevel(flag: MalawiFlag()),
                GameLevel(flag: RwandaFlag()),
                GameLevel(flag: SaoTomeAndPrincipeFlag()),
                GameLevel(flag: TanzaniaFlag()),
                GameLevel(flag: EritreaFlag()),
                GameLevel(flag: EquatorialGuineaFlag()),
                GameLevel(flag: TogoFlag()),
              ],
            ),
            GameLevelsSection(
              name: "very hard",
              difficulty: GameDifficult.extraHard,
              levels: [
                GameLevel(flag: BurundiFlag()),
                GameLevel(flag: ZimbabweFlag()),
                GameLevel(flag: CapeVerdeFlag()),
                GameLevel(flag: ComorosFlag()),
                GameLevel(flag: DemocraticRepublicOfTheCongoFlag()),
                GameLevel(flag: SouthAfricaFlag()),
                GameLevel(flag: SouthSudanFlag()),
                GameLevel(flag: EswatiniFlag()),
                GameLevel(flag: CentralAfricanRepublicFlag()),
                GameLevel(flag: UgandaFlag()),
                GameLevel(flag: NamibiaFlag()),
                GameLevel(flag: MozambiqueFlag()),
              ],
            ),
          ],
        );
}
