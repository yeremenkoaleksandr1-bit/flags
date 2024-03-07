import 'package:armar/armar.dart';
import 'package:armar/logger.dart';
import 'package:flags/core/flutter_engine.dart';
import 'package:flags/screens/games/puzzle/components/timer/timer.dart';
import 'package:flutter/cupertino.dart';

import '../../../domain/entities/game/game_levels/game_level.dart';
import '../../../presentation/game/puzzle/puzzle_fast.presenter.dart';
import '../../../presentation/presenters/levels_picker/levels_picker.presenter.dart';
import '../../../uikit/layout_components/gap/gap.dart';
import '../base/game_process_screen.dart';
import '../components/heart_tries/heart_tries.dart';
import 'common.dart';
import 'components/menu_button.dart';
import 'components/skip_level_button.dart';

class PuzzleFastMode extends PuzzleCommonMode<IPuzzleFastModePresenter> {
  const PuzzleFastMode({super.key, required super.presenter});

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
        FastModeTimer(
          timerStream: presenter.timerStream,
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
  State<ArGetScreen<IPuzzleFastModePresenter>> createState() =>
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
