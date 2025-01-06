import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:bloc_utils/bloc_utils.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/domain/entities/game/game_levels/game_levels.dart';
import 'package:flags/features/levels_picker/presentation/bloc/levels_picker_cubit.dart';
import 'package:flags/features/levels_picker/presentation/components/continent_title.dart';
import 'package:flags/features/levels_picker/presentation/view/levels_view.dart';
import 'package:flags/uikit/components/buttons/actions/actions.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LevelsPickerScreenView extends StatelessWidget {
  const LevelsPickerScreenView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ILevelsPickerCubit>();

    return BlocStateBuilder(
      listener: cubit,
      builder: (GameContinentData state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const Pad(horizontal: 8),
              child: Row(
                children: [
                  const FBackButton(),
                  Gap.h24,
                  Expanded(
                    child: ContinentTitleView(
                      title: state.name,
                    ),
                  ),
                  Gap.h24,
                ],
              ),
            ),
            Expanded(
              child: ContinentLevelsView(
                sections: state.sections,
                onSelected: (GameLevel level, GameDifficult difficult) {
                  cubit.onLevelPicked(
                    level,
                    difficult,
                    GameStyleType.common,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
