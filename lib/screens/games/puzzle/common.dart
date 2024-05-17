import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:defer_pointer/defer_pointer.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/presentation/game/puzzle/puzzle_common.presenter.dart';
import 'package:flags/screens/games/base/game_process_screen.dart';
import 'package:flags/screens/games/components/heart_tries/heart_tries.dart';
import 'package:flags/screens/games/puzzle/components/emblemb_contirmation_overlay_entry.dart';
import 'package:flags/screens/games/puzzle/components/menu_button.dart';
import 'package:flags/screens/games/puzzle/components/skip_level_button.dart';
import 'package:flags/screens/games/puzzle/views/board.dart';
import 'package:flags/screens/games/puzzle/views/boards/colored_path_editing_board.dart';
import 'package:flags/screens/games/puzzle/views/boards/emblem_editing_board.dart';
import 'package:flags/screens/games/puzzle/views/current_level_index.dart';
import 'package:flags/screens/games/puzzle/views/flag_area.dart';
import 'package:flags/screens/games/puzzle/views/level_title.dart';
import 'package:flags/uikit/components/animated/shake.dart';
import 'package:flags/uikit/components/safe_area/safe_area.dart';
import 'package:flags/uikit/layout_components/gap/gap.dart';
import 'package:flags/uikit/layout_components/showcase/showcase.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:state_manager/state_manager.dart';

class PuzzleCommonMode<T extends IPuzzleCommonModePresenter>
    extends GameProcessScreen<T> {
  const PuzzleCommonMode({super.key, required super.controller});

  Widget buildHeaderWidget(
    BuildContext context,
    T presenter,
    GameLevel level,
  ) {
    return Row(
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
        ),
      ],
    );
  }

  Widget buildHeaderMiddleWidget(
    BuildContext context,
    T presenter,
    GameLevel level,
  ) {
    return Align(
      child: CurrentLevelIndex(
        level: level,
      ),
    );
  }

  Widget buildHeader(
    BuildContext context,
    T presenter,
    GameLevel level,
  ) {
    return GameSafeArea(
      child: Padding(
        padding: const Pad(horizontal: 8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 48),
          child: Stack(
            children: [
              buildHeaderWidget(context, presenter, level),
              buildHeaderMiddleWidget(context, presenter, level),
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
    return Stack(
      fit: StackFit.passthrough,
      children: [
        GameSafeArea(
          child: Padding(
            padding: const Pad(top: 48),
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

                      final object = details.data;

                      final sizeDif =
                          (object.size * object.scale - object.size) * 2;

                      return presenter.handleGameObject(
                        renderBox
                            .globalToLocal(
                              details.offset.translate(
                                sizeDif.x,
                                sizeDif.y,
                              ),
                            )
                            .toVector2(),
                        details.data,
                      );
                    },
                    controller: presenter,
                  ),
                ),
              ],
            ),
          ),
        ),
        PartsBoard(
          controller: presenter,
          flag: level.flag,
        ),
        EmblemEditingBoard(
          controller: presenter,
        ),
        ColoredPathEditingBoard(
          controller: presenter,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, T presenter) {
    return presenter.obx(
      (state) {
        return FShowcaseWidget(
          showcaseKey: presenter.showcase.key,
          builder: (BuildContext context) {
            return ValueListenableBuilder(
              valueListenable: state!.level,
              builder: (
                BuildContext context,
                level,
                Widget? child,
              ) {
                return Stack(
                  children: [
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
}
