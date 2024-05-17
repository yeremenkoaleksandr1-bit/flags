// ignore_for_file: require_trailing_commas

import 'package:defer_pointer/defer_pointer.dart';
import 'package:flags/core/flutter_engine.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/presentation/game/puzzle/onboarding/fast_mode/fastmode.showcase_step_1.dart';
import 'package:flags/presentation/game/puzzle/onboarding/fast_mode/fastmode.showcase_step_2.dart';
import 'package:flags/presentation/game/puzzle/puzzle_fast.presenter.dart';
import 'package:flags/presentation/presenters/levels_picker/levels_picker.presenter.dart';
import 'package:flags/screens/games/base/game_process_screen.dart';
import 'package:flags/screens/games/components/heart_tries/heart_tries.dart';
import 'package:flags/screens/games/puzzle/common.dart';
import 'package:flags/screens/games/puzzle/components/emblemb_contirmation_overlay_entry.dart';
import 'package:flags/screens/games/puzzle/components/menu_button.dart';
import 'package:flags/screens/games/puzzle/components/skip_level_button.dart';
import 'package:flags/screens/games/puzzle/components/timer/timer.dart';
import 'package:flags/uikit/layout_components/gap/gap.dart';
import 'package:flags/uikit/layout_components/showcase/showcase.dart';
import 'package:flutter/cupertino.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:state_manager/state_manager.dart';

import '../../../features/audio/audio.provider.dart';
import '../../../features/audio/sound_data.dart';

class PuzzleFastMode extends PuzzleCommonMode<IPuzzleFastModePresenter> {
  const PuzzleFastMode({super.key, required super.controller});

  @override
  void onPreInit(BuildContext context) {
    final audio = AudioProvider.of(context);

    audio.playBgm(GameMusics.fastMode);
  }

  @override
  void onClose() {
    final audio = AudioProvider.of(QR.context!);

    audio.playBgm(GameMusics.continents);
  }

  @override
  Widget buildHeaderMiddleWidget(
    BuildContext context,
    IPuzzleFastModePresenter presenter,
    GameLevel level,
  ) {
    return const SizedBox.shrink();
  }

  @override
  Widget buildHeaderWidget(
    BuildContext context,
    IPuzzleFastModePresenter presenter,
    GameLevel level,
  ) {
    return Row(
      children: [
        OpenMenuButton(
          onPressed: presenter.openMenu,
        ),
        Gap.h12,
        PuzzleFastModeStep1Showcase(
          showcaseKey: presenter.showcaseFm.step1,
          onTap: () {
            presenter.showcaseFm.showcaseState.next();
          },
          child: FastModeTimer(
            timerStream: presenter.timerStream,
          ),
        ),
        const Spacer(),
        SkipLevelButton(
          onPressed: presenter.skipLevel,
        ),
        Gap.h4,
        HeartTries(
          state: presenter.heartTriesState,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context, IPuzzleFastModePresenter presenter) {
    return presenter.obx(
      (state) {
        return FShowcaseWidget(
          showcaseKey: presenter.showcaseFm.key,
          builder: (BuildContext context) {
            return ValueListenableBuilder(
              valueListenable: state!.level,
              builder: (
                BuildContext context,
                GameLevel level,
                Widget? child,
              ) {
                return Stack(
                  children: [
                    Positioned.fill(
                      child: PuzzleFastModeStep2Showcase(
                        showcaseKey: presenter.showcaseFm.step2,
                        onTap: () {
                          presenter.showcaseFm.showcaseState.next();
                          presenter.showcaseFm.complete('fast_mode');
                          presenter.showcaseFm.completeFuture?.complete();
                        },
                        child: const SizedBox.shrink(),
                      ),
                    ),
                    buildHeader(
                      context,
                      presenter,
                      level,
                    ),
                    DeferredPointerHandler(
                      child: buildBody(
                        context,
                        presenter,
                        level,
                      ),
                    ),
                    EmblemConfirmationWidget(
                      state: presenter.emblemConfirmationView,
                      onConfirm: presenter.tryPlaceFocussedEmblem,
                      onDecline: presenter.tryRemoveFocussedEmblem,
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  State<GetScreen<IPuzzleFastModePresenter>> createState() =>
      PuzzleFastModePageState();
}

class PuzzleFastModePageState
    extends GameProcessScreenState<IPuzzleFastModePresenter> {
  @override
  void didPop() {
    FlutterEngine.schedulePostFrameCallback((timeStamp) {
      Get.delete<ILevelsPickerPresenter>(tag: "single");
    });
    super.didPop();
  }
}
