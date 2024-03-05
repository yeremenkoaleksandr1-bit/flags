import 'package:armar/armar.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:defer_pointer/defer_pointer.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/presentation/game/puzzle/puzzle_common.presenter.dart';
import 'package:flags/screens/games/puzzle/views/board.dart';
import 'package:flags/screens/games/puzzle/views/current_level_index.dart';
import 'package:flags/ui/game_scaffold.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/cupertino.dart';

import '../../../uikit/components/animated/shake.dart';
import '../../../uikit/layout_components/gap/gap.dart';
import '../base/game_process_screen.dart';
import '../components/heart_tries/heart_tries.dart';
import 'components/emblemb_contirmation_overlay_entry.dart';
import 'components/menu_button.dart';
import 'components/skip_level_button.dart';
import 'views/boards/colored_path_editing_board.dart';
import 'views/boards/emblem_editing_board.dart';
import 'views/flag_area.dart';
import 'views/level_title.dart';

class PuzzleCommonMode<T extends IPuzzleCommonModePresenter>
    extends GameProcessScreen<T> {
  const PuzzleCommonMode({super.key, required super.presenter});

  Widget buildHeader(
    BuildContext context,
    T presenter,
    GameLevel level,
  ) {
    return SafeArea(
      child: Padding(
        padding: const Pad(horizontal: 8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 48),
          child: Stack(
            children: [
              Row(
                children: [
                  OpenMenuButton(
                    onPressed: presenter.openMenu,
                  ),
                  Gap.h4,
                  SkipLevelButton(
                    onPressed: presenter.skipLevel,
                  ),
                  const Spacer(),
                  HeartTries(
                    state: presenter.heartTriesState,
                  )
                ],
              ),
              Align(
                alignment: Alignment.center,
                child: CurrentLevelIndex(
                  level: level,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBody(
    BuildContext context,
    T presenter,
    GameLevel level,
  ) {
    final safeAreaTop = MediaQuery.of(context).padding.top;

    return Stack(
      fit: StackFit.passthrough,
      children: [
        Padding(
          padding: Pad(top: safeAreaTop + 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LevelTitleView(
                levelName: level.flag.name,
              ),
              ShakeWidget(
                controller: presenter.shakeAnimation,
                child: GameFlagArea(
                  flag: level.flag,
                  exposer: presenter.flagExposer,
                  objects: presenter.state.placedObjects,
                  onAcceptWithDetails: (context, details) {
                    final renderBox = context.renderBox!;

                    return presenter.handleGameObject(
                      (details.offset - renderBox.localToGlobal(Offset.zero))
                          .toVector2(),
                      details.data,
                    );
                  },
                  presenter: presenter,
                ),
              ),
            ],
          ),
        ),
        PartsBoard(
          presenter: presenter,
          flag: level.flag,
        ),
        EmblemEditingBoard(
          presenter: presenter,
        ),
        ColoredPathEditingBoard(
          presenter: presenter,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, T presenter) {
    return GameTransitionPageBuilder(
      startSlideDirection: GamePageSlideDirection.middle,
      endSlideDirection: GamePageSlideDirection.bottom,
      child: DeferredPointerHandler(
        child: presenter.obx(
          (state) => FastBuilder(
            () {
              final level = state!.level.value;
              return Stack(
                children: [
                  buildHeader(
                    context,
                    presenter,
                    level,
                  ),
                  buildBody(
                    context,
                    presenter,
                    level,
                  ),
                  EmblemConfirmationWidget(
                    state: presenter.emblemConfirmationView,
                    onConfirm: presenter.tryPlaceFocussedEmblem,
                    onDecline: presenter.tryRemoveFocussedEmblem,
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
