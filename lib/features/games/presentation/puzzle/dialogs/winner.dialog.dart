import 'package:drag_and_drop/extensions/render_box.dart';
import 'package:flags/core/flutter_engine.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/domain/game_objects/emblems/emblem.gameObject.dart';
import 'package:flags/features/games/presentation/puzzle/dialogs/components/added_money.view.dart';
import 'package:flags/features/games/presentation/puzzle/dialogs/components/new_emblems_view.dart';
import 'package:flags/services/layers/money_layer/money_layer.dart';
import 'package:flags/ui/dialogs/dialogs.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/game_widgets/flag/flag.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PuzzleWinnerDialog extends DialogWidget {
  PuzzleWinnerDialog({
    super.key,
    required this.level,
    this.nextLevel,
    required this.onExitPressed,
    required this.emblems,
    required this.isLastLevelInSection,
    required this.onNextLevelPressed,
  });

  final GlobalKey _moneyStartWidget = GlobalKey();

  final GameLevel level;
  final GameLevel? nextLevel;

  final List<EmblemPart> emblems;
  final bool isLastLevelInSection;

  final void Function(BuildContext context) onExitPressed;
  final void Function(BuildContext context) onNextLevelPressed;

  bool isAnimationPlayed = false;

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

    if (showMoneyAward && !isAnimationPlayed) {
      isAnimationPlayed = true;
      FlutterEngine.widgetPostFrameCallback((timeStamp) {
        if (_moneyStartWidget.currentContext != null) {
          final renderBox = _moneyStartWidget.currentContext!
              .findRenderObject()! as RenderBox;

          final rect = renderBox.rect;

          final uiMoneyLayer = UiMoneyLayer.find();

          uiMoneyLayer.show().then(
            (value) async {
              await uiMoneyLayer.addMoneys(
                rect.center,
                addMoneyView.clamp(1, 50),
              );

              await Future.delayed(
                const Duration(
                  milliseconds: 1250,
                ),
              );

              await uiMoneyLayer.hide();
            },
          );
        }
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      spacing: 24,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: FText(
                    "${level.flag.name} - completed!",
                    textStyle: const TextStyle(
                      fontSize: 48,
                    ),
                  ),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: FlagView(flag: level.flag),
            ),
          ],
        ),
        if (showAward)
          FCard(
            color: ThemePalette.peach,
            child: Column(
              spacing: 12,
              children: [
                if (showMoneyAward)
                  AddedMoneyView(
                    money: addMoneyView,
                    widgetKey: _moneyStartWidget,
                  ),
                if (showEmblemsAward)
                  PuzzleNewEmblemView(
                    emblems: emblems,
                  ),
              ],
            ),
          ),
        Column(
          spacing: 8,
          children: [
            FGreenButton(
              onPressed: () => onNextLevelPressed(context),
              child: Center(
                child: FText(
                  nextLevelButtonText,
                  textStyle: const TextStyle(
                    fontSize: 48,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FRedButton(
                onPressed: () => onExitPressed(context),
                child: Center(
                  child: FText("Menu"),
                ),
              ),
            ),
          ],
        ),
        // if (IAppCubit.isDebugMode) ...[
        //   Column(
        //     children: [
        //       Text("nextLevel: ${nextLevel?.flag.name}"),
        //       Text("is Last Level In Continent: $isLastLevelInContinent"),
        //       Text("is Current Level Completed: $isCurrentLevelCompleted"),
        //       Text("is Last Level In Section: $isLastLevelInSection"),
        //       Text("level Emblems: ${emblems.length}"),
        //     ],
        //   ),
        // ],
      ],
    );
  }
}
