import '../../domain/domain.dart';
import '../../domain/entities/game/game.dart';
import '../../domain/entities/game/game_levels/game_level.dart';
import '../flags/asia.dart';

class AsiaContinent extends GameContinentData {
  AsiaContinent()
      : super(
          name: "Asia",
          sections: <GameLevelsSection>[
            GameLevelsSection(
              name: "very easy",
              difficulty: GameDifficult.superEasy,
              levels: [
                GameLevel(flag: JapanFlag(), opened: true),
                GameLevel(flag: VietnamFlag()),
                GameLevel(flag: HongKongFlag()),
                GameLevel(flag: AfghanistanFlag()),
                GameLevel(flag: BangladeshFlag()),
                GameLevel(flag: KyrgyzstanFlag()),
                GameLevel(flag: QatarFlag()),
                GameLevel(flag: IndonesiaFlag()),
                GameLevel(flag: BahrainFlag()),
              ],
            ),
            GameLevelsSection(
              name: "easy",
              difficulty: GameDifficult.easy,
              levels: [
                GameLevel(flag: ChinaFlag()),
                GameLevel(flag: SaudiArabiaFlag()),
                GameLevel(flag: YemenFlag()),
                GameLevel(flag: MacauFlag()),
                GameLevel(flag: KuwaitFlag()),
                GameLevel(flag: IsraelFlag()),
                GameLevel(flag: UnitedArabEmiratesFlag()),
                GameLevel(flag: ArmeniaFlag()),
                GameLevel(flag: PalestineFlag()),
              ],
            ),
            GameLevelsSection(
              name: "medium",
              difficulty: GameDifficult.medium,
              levels: [
                GameLevel(flag: IndiaFlag()),
                GameLevel(flag: MyanmarFlag()),
                GameLevel(flag: SouthKoreaFlag()),
                GameLevel(flag: IraqFlag()),
                GameLevel(flag: SingaporeFlag()),
                GameLevel(flag: PhilippinesFlag()),
                GameLevel(flag: TaiwanFlag()),
                GameLevel(flag: TajikistanFlag()),
                GameLevel(flag: PakistanFlag()),
                GameLevel(flag: LaosFlag()),
                GameLevel(flag: CambodiaFlag()),
                GameLevel(flag: SyriaFlag()),
                GameLevel(flag: LebanonFlag()),
              ],
            ),
            GameLevelsSection(
              name: "hard",
              difficulty: GameDifficult.hard,
              levels: [
                GameLevel(flag: MalaysiaFlag()),
                GameLevel(flag: TurkmenistanFlag()),
                GameLevel(flag: IranFlag()),
                GameLevel(flag: EastTimorFlag()),
                GameLevel(flag: NorthKoreaFlag()),
                GameLevel(flag: MongoliaFlag()),
                GameLevel(flag: ThailandFlag()),
                GameLevel(flag: MaldivesFlag()),
                GameLevel(flag: NepalFlag()),
              ],
            ),
            GameLevelsSection(
              name: "extra hard",
              difficulty: GameDifficult.extraHard,
              levels: [
                GameLevel(flag: SriLankaFlag()),
                GameLevel(flag: BruneiFlag()),
                GameLevel(flag: BhutanFlag()),
                GameLevel(flag: JordanFlag()),
                GameLevel(flag: UzbekistanFlag()),
                GameLevel(flag: OmanFlag()),
              ],
            ),
          ],
        );
}
