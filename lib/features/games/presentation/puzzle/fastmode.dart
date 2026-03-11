// ignore_for_file: require_trailing_commas

import 'package:bloc_utils/bloc_utils.dart';
import 'package:defer_pointer/defer_pointer.dart';
import 'package:flags/features/app/features/audio/domain/sound_data.dart';
import 'package:flags/features/games/presentation/components/heart_tries/heart_tries.dart';
import 'package:flags/features/games/presentation/puzzle/common.dart';
import 'package:flags/features/games/presentation/puzzle/components/emblemb_contirmation_overlay_entry.dart';
import 'package:flags/features/games/presentation/puzzle/components/menu_button.dart';
import 'package:flags/features/games/presentation/puzzle/components/timer/timer.dart';
import 'package:flags/presentation/game/puzzle/onboarding/fast_mode/fastmode.showcase_step_1.dart';
import 'package:flags/presentation/game/puzzle/onboarding/fast_mode/fastmode.showcase_step_2.dart';
import 'package:flags/presentation/game/puzzle/puzzle_fast.presenter.dart';
import 'package:flags/presentation/game/puzzle/state/puzzle_game.state.dart';
import 'package:flags/uikit/layout_components/gap/gap.dart';
import 'package:flags/uikit/layout_components/showcase/showcase.dart';
import 'package:flutter/cupertino.dart';

class PuzzleFastModeView extends PuzzleCommonModeView<PuzzleFastModeCubit> {
  const PuzzleFastModeView({super.key, required super.cubit});

  @override
  PuzzleFastModeViewState createState() => PuzzleFastModeViewState();
}

class PuzzleFastModeViewState
    extends PuzzleCommonModeViewState<PuzzleFastModeCubit> {
  @override
  PuzzleFastModeCubit get cubit => widget.cubit;

  @override
  void initState() {
    super.initState();
    audioCubit.playBgm(GameMusics.fastMode);
  }



  @override
  Widget buildHeaderMiddleWidget(
    BuildContext context,
    PuzzleGameState state,
  ) {
    return const SizedBox.shrink();
  }

  @override
  Widget buildHeaderWidget(
    BuildContext context,
    PuzzleGameState state,
  ) {
    return Row(
      children: [
        OpenMenuButton(
          onPressed: () => cubit.openMenu(context),
        ),
        Gap.h12,
        PuzzleFastModeStep1Showcase(
          showcaseKey: cubit.showcaseFm.step1,
          onTap: cubit.showcaseFm.next,
          child: FastModeTimer(
            timerStream: cubit.timerStream,
          ),
        ),
        const Spacer(),
        // SkipLevelButton(
        //   onPressed: cubit.skipLevel,
        // ),
        Gap.h4,
        HeartTries(
          state: cubit.heartTriesState,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocDynamicStateBuilder(
      bloc: cubit,
      builder: (BuildContext context, state) {
        return FShowcaseWidget(
          showcaseKey: cubit.showcaseFm.key,
          builder: (BuildContext context) {
            return Stack(
              children: [
                Positioned.fill(
                  child: PuzzleFastModeStep2Showcase(
                    showcaseKey: cubit.showcaseFm.step2,
                    onTap: () {
                      cubit.showcaseFm.next();
                      cubit.showcaseFm.complete('fast_mode');
                      cubit.showcaseFm.completeFuture?.complete();
                    },
                    child: const SizedBox.shrink(),
                  ),
                ),
                buildHeader(
                  context,
                  state,
                ),
                DeferredPointerHandler(
                  child: buildBody(
                    context,
                    state,
                  ),
                ),
                EmblemConfirmationWidget(
                  state: cubit.emblemConfirmationView,
                  onConfirm: cubit.tryPlaceFocussedEmblem,
                  onDecline: cubit.tryRemoveFocussedEmblem,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
