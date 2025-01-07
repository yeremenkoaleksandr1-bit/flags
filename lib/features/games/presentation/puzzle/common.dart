import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:bloc_utils/bloc_utils.dart';
import 'package:defer_pointer/defer_pointer.dart';
import 'package:flags/features/app/features/audio/presentation/bloc/audio_cubit.dart';
import 'package:flags/features/games/presentation/base/game_process_screen.dart';
import 'package:flags/features/games/presentation/components/heart_tries/heart_tries.dart';
import 'package:flags/features/games/presentation/puzzle/components/emblemb_contirmation_overlay_entry.dart';
import 'package:flags/features/games/presentation/puzzle/components/menu_button.dart';
import 'package:flags/features/games/presentation/puzzle/components/skip_level_button.dart';
import 'package:flags/features/games/presentation/puzzle/views/board.dart';
import 'package:flags/features/games/presentation/puzzle/views/boards/colored_path_editing_board.dart';
import 'package:flags/features/games/presentation/puzzle/views/boards/emblem_editing_board.dart';
import 'package:flags/features/games/presentation/puzzle/views/current_level_index.dart';
import 'package:flags/features/games/presentation/puzzle/views/flag_area.dart';
import 'package:flags/features/games/presentation/puzzle/views/level_title.dart';
import 'package:flags/presentation/game/puzzle/puzzle_common.presenter.dart';
import 'package:flags/presentation/game/puzzle/state/puzzle_game.state.dart';
import 'package:flags/uikit/components/animated/shake.dart';
import 'package:flags/uikit/components/safe_area/safe_area.dart';
import 'package:flags/uikit/layout_components/gap/gap.dart';
import 'package:flags/uikit/layout_components/showcase/showcase.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PuzzleCommonModeView<T extends IPuzzleCommonModeCubit>
    extends GameProcessScreen<T> {
  const PuzzleCommonModeView({
    super.key,
    required super.cubit,
  });

  @override
  State<GameProcessScreen<T>> createState() => PuzzleCommonModeViewState();
}

class PuzzleCommonModeViewState<T extends IPuzzleCommonModeCubit>
    extends GameProcessScreenState<T> {
  T get cubit => widget.cubit;

  IAudioCubit get audioCubit => context.read<IAudioCubit>();

  Widget buildHeaderWidget(
    BuildContext context,
    PuzzleGameState state,
  ) {
    return Row(
      children: [
        OpenMenuButton(
          onPressed: () => cubit.openMenu(context),
        ),
        // Gap.h4,
        // SkipLevelButton(
        //   onPressed: cubit.skipLevel,
        // ),
        const Spacer(),
        HeartTries(
          state: cubit.heartTriesState,
        ),
      ],
    );
  }

  Widget buildHeaderMiddleWidget(
    BuildContext context,
    PuzzleGameState state,
  ) {
    return Align(
      child: CurrentLevelIndex(
        level: state.level,
      ),
    );
  }

  Widget buildHeader(
    BuildContext context,
    PuzzleGameState state,
  ) {
    return GameSafeArea(
      child: Padding(
        padding: const Pad(horizontal: 8),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 48),
          child: Stack(
            children: [
              buildHeaderWidget(context, state),
              buildHeaderMiddleWidget(context, state),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBody(
    BuildContext context,
    PuzzleGameState state,
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
                  levelName: state.level.flag.name,
                ),
                ShakeWidget(
                  controller: cubit.shakeAnimation,
                  child: GameFlagArea(
                    flag: state.level.flag,
                    exposer: cubit.flagExposer,
                    objects: state.placedObjects,
                    onAcceptWithDetails: (context, details) {
                      final renderBox =
                          context.findRenderObject()! as RenderBox;

                      final object = details.data;

                      final sizeDif =
                          (object.size * object.scale - object.size) * 2;

                      return cubit.handleGameObject(
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
                    cubit: cubit,
                  ),
                ),
              ],
            ),
          ),
        ),
        PartsBoard(
          cubit: cubit,
          state: state,
        ),
        EmblemEditingBoard(
          cubit: cubit,
        ),
        ColoredPathEditingBoard(
          cubit: cubit,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocStateBuilder(
      listener: cubit,
      builder: (PuzzleGameState state) {
        return FShowcaseWidget(
          showcaseKey: cubit.showcase.key,
          builder: (BuildContext context) {
            return Stack(
              children: [
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
