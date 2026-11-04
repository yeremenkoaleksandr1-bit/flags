import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/navigator/router.gr.dart';
import 'package:flags/presentation/presenters/continents_picker/route_params.dart';
import 'package:flags/features/app/features/audio/domain/sound_data.dart';
import 'package:flags/features/app/features/audio/presentation/bloc/audio_cubit.dart';
import 'package:flags/ui/blackout_transition.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flags/ui/game_scaffold.dart';
import 'package:flags/uikit/components/buttons/actions/actions.dart';
import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flags/uikit/theme/indents.dart';
import 'package:flutter/material.dart';

import 'views/coming_soon.dart';
import 'views/flappy_mode_view.dart';
import 'views/puzzles_mode_view.dart';

@RoutePage()
class GameModePickerScreen extends StatelessWidget {
  const GameModePickerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Каждый режим — пара (виджет-превью, колбэк при нажатии)
    final modes = <(Widget, VoidCallback)>[
      (
        const PuzzleModeView(),
        () => context.navigateTo(
          ContinentsPickerRouter(
            params: ContinentPickerRouteParams(
              gameProcessType: GameProcessType.puzzle,
            ),
          ),
        ),
      ),
      (
        const FlappyModeView(),
        // переход в горизонтальный режим — под затемнением
        () => BlackoutTransition.run(
          context,
          () => context.navigateTo(const FlappyFlagPickerRoute()),
          hold: const Duration(milliseconds: 550),
          rotation: RotationHint.toLandscape,
        ),
      ),
    ];

    return GamePageBuilder(
      // при возврате из списка флагов (он ставит музыку на паузу) — снова музыка меню
      onPageFocussed: () =>
          context.read<IAudioCubit>().playBgm(GameMusics.main),
      startSlideDirection: GamePageSlideDirection.right,
      endSlideDirection: GamePageSlideDirection.right,
      child: Stack(
        children: [
          // вертикальный список режимов; снизу отступ под кнопку назад
          ListView(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 40,
              bottom: 140,
            ),
            children: [
              for (final (view, onTap) in modes)
                Padding(
                  // место под заголовок, который выступает над карточкой
                  padding: const EdgeInsets.only(top: 40),
                  child: ScaledGestureDetector(onTap: onTap, child: view),
                ),
              // заглушка нажимается: прогиб + маленькая говорящая пасхалка
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: ScaledGestureDetector(
                  onTap: () => showComingSoonModeTalk(context),
                  child: const GameModeComingSoon(),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: Pad(bottom: ThemeIndents.s12),
              child: const FBackButton(),
            ),
          ),
        ],
      ),
    );
  }
}
