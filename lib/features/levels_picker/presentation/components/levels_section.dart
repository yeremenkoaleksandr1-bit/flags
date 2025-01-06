import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/domain/entities/game/game.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/uikit/layout_components/gap/gap.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flutter/material.dart';

import 'level_button.dart';

class ContinentLevelsSection extends StatelessWidget {
  const ContinentLevelsSection({
    super.key,
    required this.section,
    required this.onLevelSelected,
  });

  final GameLevelsSection section;
  final void Function(GameLevel level) onLevelSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const Pad(vertical: 12),
          child: Row(
            children: [
              const Expanded(
                child: Divider(
                  color: ThemePalette.black,
                ),
              ),
              Gap.h12,
              FText(
                section.name,
                strokeWidth: 4,
              ),
              Gap.h12,
              const Expanded(
                child: Divider(
                  color: ThemePalette.black,
                ),
              ),
            ],
          ),
        ),
        WrapSuper(
          spacing: 24,
          lineSpacing: 24,
          wrapFit: WrapFit.proportional,
          children: [
            ...section.levels.map(
              (e) => LevelButton(
                level: e,
                isOpened: e.opened,
                difficult: section.difficulty,
                onLevelSelected: onLevelSelected,
              ),
            ),
          ],
        )
      ],
    );
  }
}
