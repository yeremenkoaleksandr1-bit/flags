import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:bloc_utils/bloc_utils.dart';
import 'package:defer_pointer/defer_pointer.dart';
import 'package:drag_and_drop/drag_and_drop.dart';
import 'package:flags/domain/game_objects/base/process.game_object.dart';
import 'package:flags/features/app/features/audio/presentation/bloc/audio_cubit.dart';
import 'package:flags/features/app/presentation/bloc/app_cubit.dart';
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

class PuzzleCommonModeView<T extends PuzzleCommonModeCubit>
    extends GameProcessScreen<T> {
  const PuzzleCommonModeView({super.key, required super.cubit});

  @override
  State<GameProcessScreen<T>> createState() => PuzzleCommonModeViewState();
}

class PuzzleCommonModeViewState<T extends PuzzleCommonModeCubit>
    extends GameProcessScreenState<T> {
  static const double _flagSectionMinHeight = 220;
  static const double _flagSectionMaxHeight = 420;
  static const double _flagSectionHeightFactor = 0.42;

  T get cubit => widget.cubit;
  IAudioCubit get audioCubit => context.read<IAudioCubit>();

  Widget buildHeaderWidget(BuildContext context, PuzzleGameState state) {
    final appCubit = context.read<IAppCubit>();

    return Row(
      children: [
        OpenMenuButton(onPressed: () => cubit.openMenu(context)),
        if (appCubit.preferences.isDebugMode) ...[
          Gap.h4,
          SkipLevelButton(onPressed: cubit.skipLevel),
        ],
        const Spacer(),
        HeartTries(state: cubit.heartTriesState),
      ],
    );
  }

  Widget buildHeaderMiddleWidget(BuildContext context, PuzzleGameState state) {
    return Align(child: CurrentLevelIndex(level: state.level));
  }

  Widget buildHeader(BuildContext context, PuzzleGameState state) {
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

  Widget buildBody(BuildContext context, PuzzleGameState state) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        GameSafeArea(
          child: Padding(
            padding: const Pad(top: 48),
            child: buildFlagSection(context, state),
          ),
        ),
        ...buildOverlayBoards(state),
      ],
    );
  }

  Widget buildFlagSection(BuildContext context, PuzzleGameState state) {
    final mediaQuery = MediaQuery.of(context);
    final safeHeight = mediaQuery.size.height - mediaQuery.padding.vertical;
    final flagSectionHeight = (safeHeight * _flagSectionHeightFactor).clamp(
      _flagSectionMinHeight,
      _flagSectionMaxHeight,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LevelTitleView(levelName: state.level.flag.name),
        SizedBox(
          height: flagSectionHeight,
          child: ShakeWidget(
            controller: cubit.shakeAnimation,
            child: GameFlagArea(
              flag: state.level.flag,
              exposer: cubit.flagExposer,
              objects: state.placedObjects,
              onAcceptWithDetails: handleFlagObjectDrop,
              cubit: cubit,
            ),
          ),
        ),
      ],
    );
  }

  Iterable<Widget> buildOverlayBoards(PuzzleGameState state) {
    return [
      PartsBoard(
        cubit: cubit,
        boardObjects: [...state.boardObjects],
        flag: state.flag,
      ),
      EmblemEditingBoard(cubit: cubit),
      ColoredPathEditingBoard(cubit: cubit),
    ];
  }

  bool handleFlagObjectDrop(
    BuildContext context,
    SDragTargetDetails<ProcessGameObject> details,
  ) {
    final renderBox = context.findRenderObject()! as RenderBox;
    final localOffset = resolveDropOffset(renderBox, details);

    return cubit.handleGameObject(localOffset.toVector2(), details.data);
  }

  Offset resolveDropOffset(
    RenderBox renderBox,
    SDragTargetDetails<ProcessGameObject> details,
  ) {
    final object = details.data;
    final sizeOffset = (object.size * object.scale - object.size) * 2;

    return renderBox.globalToLocal(
      details.offset.translate(sizeOffset.x, sizeOffset.y),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocDynamicStateBuilder(
      bloc: cubit,
      builder: (BuildContext context, PuzzleGameState state) {
        return FShowcaseWidget(
          showcaseKey: cubit.showcase.key,
          builder: (BuildContext context) {
            return Stack(
              children: [
                buildHeader(context, state),
                DeferredPointerHandler(child: buildBody(context, state)),
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
