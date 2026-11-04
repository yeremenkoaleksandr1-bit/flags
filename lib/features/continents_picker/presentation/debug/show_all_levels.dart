import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/prefabs/levels/levels.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flutter/material.dart';

class ShowAllLevelsDebug extends StatefulWidget {
  const ShowAllLevelsDebug({super.key});

  @override
  State<ShowAllLevelsDebug> createState() => _ShowAllLevelsDebugState();
}

class _ShowAllLevelsDebugState extends State<ShowAllLevelsDebug> {
  Future<void> showLevels() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        final levels = [...FactoryGameContinent.allLevels]..sort(
            (a, b) => a.flag.name.compareTo(b.flag.name),
          );

        return _Dialog(levels: levels);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FGreenButton(
      onPressed: showLevels,
      child: const Text("show all levels"),
    );
  }
}

class _Dialog extends StatelessWidget {
  const _Dialog({
    required this.levels,
  });

  final List<GameLevel> levels;

  @override
  Widget build(BuildContext context) {
    void onBack() {
      Navigator.of(context).pop();
    }

    return Padding(
      padding: const Pad(horizontal: 8, bottom: 8, top: 48),
      child: Material(
        color: ThemePalette.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        child: Column(
          children: [
            ActionChip(
              label: const Text("close"),
              onPressed: onBack,
            ),
            Expanded(
              child: ListView(
                children: [
                  ...levels.map(
                    (e) => ListTile(
                      onTap: () {
                        onBack();

                        // QR.toName(
                        //   Routes.gameProcessFactory,
                        //   params: {
                        //     'data': GamesFactoryPageParams(
                        //       level: e,
                        //       difficult: GameDifficult.extraHard,
                        //       gamesType: GameStyleType.common,
                        //       gameMode: GameProcessType.puzzle,
                        //       continentType: ContinentType.europe,
                        //     ),
                        //   },
                        // );
                      },
                      title: Text(e.flag.name),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
