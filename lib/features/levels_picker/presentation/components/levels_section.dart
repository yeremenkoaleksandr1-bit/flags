import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/domain/entities/game/game.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/features/app/domain/models/game/game_mode_data.dart';
import 'package:flags/features/app/features/levels/presentation/bloc/levels_cubit.dart';
import 'package:flags/uikit/layout_components/gap/gap.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'level_button.dart';

class ContinentLevelsSection extends StatelessWidget {
  const ContinentLevelsSection({
    super.key,
    required this.section,
    required this.onLevelSelected,
    required this.continent,
  });

  final ContinentType continent;

  final GameLevelsSection section;
  final void Function(GameLevel level) onLevelSelected;

  @override
  Widget build(BuildContext context) {
    final gameLevelsCubit = context.read<GameLevelsCubit>();

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
        BlocBuilder<GameLevelsCubit, GameModeProgressData>(
          builder: (BuildContext context, GameModeProgressData state) {
            return WrapSuper(
              spacing: 24,
              lineSpacing: 24,
              wrapFit: WrapFit.proportional,
              children: [
                ...section.levels.map(
                  (e) {
                    final bool isOpened;
                    if (e.id == 0) {
                      isOpened = true;
                    } else {
                      isOpened = gameLevelsCubit
                              .getLevelData(
                                continent,
                                (e.id - 1).clamp(0, 99999),
                              )
                              ?.completed ??
                          false;
                    }

                    return LevelButton(
                      level: e,
                      isOpened: isOpened,
                      difficult: section.difficulty,
                      onLevelSelected: isOpened ? onLevelSelected : null,
                    );
                  },
                ),
              ],
            );
          },
        )
      ],
    );
  }
}
