import 'dart:ui';

import 'package:flags/domain/domain.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/uikit/assets/assets.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/layout_components/sprite_widget.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

import '../dialogs/flag_view.dialog.dart';
import '../features/color_by_difficult.dart';

class LevelButton extends StatefulWidget {
  const LevelButton({
    super.key,
    required this.level,
    required this.isOpened,
    required this.difficult,
    required this.onLevelSelected,
  });

  final GameLevel level;

  final GameDifficult difficult;
  final bool isOpened;

  final void Function(GameLevel level) onLevelSelected;

  @override
  State<LevelButton> createState() => _LevelButtonState();
}

class _LevelButtonState extends State<LevelButton> {
  void shoeFlagDialog() {
    if (!widget.level.completed) return;
    FlagViewDialog(
      flag: widget.level.flag,
    ).showModal(context);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.level,
      builder: (BuildContext context, _) {
        late final fColor = widget.isOpened
            ? getColorByDifficult(widget.difficult)
            : ThemePalette.gray;

        var color = fColor;
        if (!widget.level.completed && widget.level.opened) {
          color = fColor.withValues(
            red: 100,
            green: 100,
            blue: 100,
          );
        }
        Widget child;

        if (widget.isOpened) {
          child = FText(
            widget.level.flag.name,
            strokeWidth: 5,
            strokeColor: color.darken(0.7),
            textAlign: TextAlign.center,
          );
        } else {
          child = SizedBox.square(
            dimension: 64,
            child: Center(
              child: SpriteUIWidget(
                image: Assets.images.lock.image,
              ),
            ),
          );
        }

        return FButton(
          onPressed: () => widget.onLevelSelected(widget.level),
          onLongPress: shoeFlagDialog,
          color: color,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 64, minWidth: 64),
                child: Center(
                  child: child,
                ),
              ),
              Positioned(
                top: -8,
                left: 0,
                child: FText(
                  "${widget.level.id + 1}",
                  strokeWidth: 2,
                  strokeColor: color.darken(0.2),
                  textStyle: const TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
