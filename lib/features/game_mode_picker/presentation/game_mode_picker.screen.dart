import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/navigator/router.gr.dart';
import 'package:flags/presentation/presenters/continents_picker/route_params.dart';
import 'package:flags/presentation/presenters/game_mode_picker/game_mode_picker.presenter.dart';
import 'package:flags/ui/game_scaffold.dart';
import 'package:flags/uikit/components/buttons/actions/actions.dart';
import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flags/uikit/theme/indents.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'views/coming_soon.dart';
import 'views/puzzles_mode_view.dart';

@RoutePage()
class GameModePickerScreen extends StatelessWidget{
  const GameModePickerScreen({
    super.key,
  });



  @override
  Widget build(BuildContext context) {
    final cubit = context.read<IGameModePickerCubit>();

    final data = {
      GameProcessType.puzzle: const PuzzleModeView(),
    };

    final entries = data.entries;

    void onGamePicked(GameProcessType type) {
      context.navigateTo(
        ContinentsPickerRouter(
          params: ContinentPickerRouteParams(
            gameProcessType: type,
          ),
        ),
      );
    }

    return GamePageBuilder(
      startSlideDirection: GamePageSlideDirection.right,
      endSlideDirection: GamePageSlideDirection.right,
      child: Stack(
        children: [
          PageView.builder(
            itemBuilder: (BuildContext context, int index) {
              if (entries.length == index) {
                return const GameModeComingSoon();
              }

              final entry = entries.elementAt(index);

              return ScaledGestureDetector(
                onTap: () => onGamePicked(entry.key),
                child: entry.value,
              );
            },
            itemCount: entries.length + 1,
          ),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: Pad(bottom: ThemeIndents.s12),
              child: FBackButton(),
            ),
          ),
        ],
      ),
    );
  }
}
