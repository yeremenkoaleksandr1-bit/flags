import 'package:armar/armar.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/domain/game_objects/emblems/emblem.gameObject.dart';
import 'package:flags/ui/dialogs/dialogs.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../uikit/uikit.dart';
import 'components/added_money.view.dart';
import 'components/new_emblems_view.dart';

class PuzzleWinnerDialog extends DialogWidget {
  const PuzzleWinnerDialog({
    super.key,
    required this.level,
    this.nextLevel,
    required this.onExitPressed,
    required this.emblems,
    required this.isLastLevelInSection,
    required this.onNextLevelPressed,
  });

  final GameLevel level;
  final GameLevel? nextLevel;

  final List<EmblemPart> emblems;
  final bool isLastLevelInSection;

  final VoidCallback onExitPressed;
  final void Function() onNextLevelPressed;

  @override
  Widget build(BuildContext context) {
    final isLastLevelInContinent =
        nextLevel == null && isLastLevelInSection == false;

    final isCurrentLevelCompleted = level.completed;

    var nextLevelButtonText = "";

    if (!isLastLevelInContinent) {
      if (!isLastLevelInSection) {
        nextLevelButtonText = "Next level ${nextLevel!.id + 1}";
      } else {
        nextLevelButtonText = "Next section";
      }
    }

    final addMoneyView = !level.completed ? level.id : 0;

    final showMoneyAward = addMoneyView != 0;
    final showEmblemsAward = emblems.isNotEmpty;
    final showAward = showMoneyAward || showEmblemsAward;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: FText(
              "You are winner!",
              textStyle: const TextStyle(
                fontSize: 48,
              ),
            ),
          ),
        ),
        if (showAward)
          FCard(
            color: ThemePalette.peach,
            child: ColumnSuper(
              innerDistance: 12,
              children: [
                if (showMoneyAward)
                  AddedMoneyView(
                    money: addMoneyView,
                  ),
                if (showEmblemsAward)
                  PuzzleNewEmblemView(
                    emblems: emblems,
                  ),
              ],
            ),
          ),
        Gap.v24,
        FGreenButton(
          onPressed: onNextLevelPressed,
          child: Center(
            child: FText(
              nextLevelButtonText,
              textStyle: const TextStyle(
                fontSize: 48,
              ),
            ),
          ),
        ),
        Gap.v24,
        FRedButton(
          onPressed: onExitPressed,
          child: Center(
            child: FText("Back to flags"),
          ),
        ),
        Gap.v48,
        Text("nextLevel: ${nextLevel?.flag.name}"),
        Text("is Last Level In Continent: $isLastLevelInContinent"),
        Text("is Current Level Completed: $isCurrentLevelCompleted"),
        Text("is Last Level In Section: $isLastLevelInSection"),
        Text("level Emblems: ${emblems.length}"),
      ],
    );
  }
}
