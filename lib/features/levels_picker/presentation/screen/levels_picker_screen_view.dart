import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:bloc_utils/bloc_utils.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/domain/entities/game/game_levels/game_levels.dart';
import 'package:flags/features/games/presentation/games_factory.page.dart';
import 'package:flags/features/levels_picker/presentation/bloc/levels_picker_cubit.dart';
import 'package:flags/features/levels_picker/presentation/components/continent_title.dart';
import 'package:flags/features/levels_picker/presentation/view/levels_view.dart';
import 'package:flags/navigator/router.gr.dart';
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

    void onLevelPicked(GameLevel level, GameDifficult difficult) {
      context.router.push(
        GamesFactoryRoute(
          params: GamesFactoryPageParams(
            level: level,
            difficult: difficult,
            gamesType: GameStyleType.common,
            gameMode: cubit.gameProcessType,
            continentType: cubit.continentType,
          ),
        ),
      );
    }

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
                onSelected: onLevelPicked,
              ),
            ),
          ],
        );
      },
    );
  }
}
