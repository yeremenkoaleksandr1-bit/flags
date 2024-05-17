// ignore_for_file: no_logic_in_create_state

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:collection/collection.dart';
import 'package:drag_and_drop/drag_and_drop.dart';
import 'package:drag_and_drop/extensions/render_box.dart';
import 'package:flags/core/flutter_engine.dart';
import 'package:flags/domain/game_objects/base/process.game_object.dart';
import 'package:flags/domain/game_objects/flag/flag.dart';
import 'package:flags/presentation/game/puzzle/entities/board_item.dart';
import 'package:flags/presentation/game/puzzle/entities/colored_part.game_object.dart';
import 'package:flags/presentation/game/puzzle/puzzle_common.presenter.dart';
import 'package:flags/screens/games/puzzle/components/board_items/base.dart';
import 'package:flags/screens/games/puzzle/components/board_items/colored_item.dart';
import 'package:flags/screens/games/puzzle/components/board_items/common_item.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/material.dart';
import 'package:state_manager/state_manager.dart';

class PartsBoard extends StatefulWidget {
  const PartsBoard({
    super.key,
    required this.controller,
    required this.flag,
    this.onDragStarted,
    this.onDragUpdate,
    this.onDraggableCanceled,
    this.onDragEnd,
    this.onDragCompleted,
  });

  final GameFlag flag;
  final IPuzzleCommonModePresenter controller;

  final void Function(ProcessGameObject object)? onDragStarted;
  final void Function(ProcessGameObject object, DragUpdateDetails details)?
      onDragUpdate;
  final void Function(
    ProcessGameObject object,
    Velocity velocity,
    Offset offset,
  )? onDraggableCanceled;

  final void Function(
    ProcessGameObject object,
    SDraggableDetails details,
  )? onDragEnd;
  final void Function(ProcessGameObject object)? onDragCompleted;

  @override
  State<PartsBoard> createState() => controller.boardController;
}

class PartsBoardState extends State<PartsBoard> {
  final ValueNotifier<bool> activeDragging = ValueNotifier(true);
  final ValueNotifier<bool> isFullScreen = ValueNotifier(false);

  final ValueNotifier<double> _positionRx = ValueNotifier(0.0);

  double _boardActualPosition = 0;
  late final _mediaQueryPaddingTop = context.mediaQueryPadding.top;

  @override
  void initState() {
    FlutterEngine.schedulePostFrameCallback((timeStamp) {
      widget.controller.flagExposer.renderBox.addListener(
        renderBoxListenFunc,
      );
    });
    super.initState();
  }

  void renderBoxListenFunc() {
    final value = widget.controller.flagExposer.renderBox.value;
    if (value != null) {
      try {
        isFullScreen.value = false;
        _positionRx.value = value.rect.bottom;
        _boardActualPosition = _positionRx.value;
      } catch (e) {}
    }
  }

  @override
  void dispose() {
    activeDragging.dispose();
    isFullScreen.dispose();

    _positionRx.dispose();

    super.dispose();
  }

  void closeFullScreen() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      isFullScreen.value = false;
      _positionRx.value = _boardActualPosition;
    });
  }

  bool _isResizableDragStart = false;

  late double _initialPosition = _positionRx.value;

  void _onPointerStart(PointerDownEvent e) {
    _isResizableDragStart = true;
  }

  void _onPointerMode(PointerMoveEvent e) {
    final difference = (_initialPosition - _positionRx.value).abs();
    if (difference < 100) {
      _positionRx.value = (_positionRx.value + e.delta.dy).clamp(
        -_mediaQueryPaddingTop,
        double.infinity,
      );
    } else {
      _positionRx.value += e.delta.dy / (1 + difference / 80);
    }
  }

  void _onPointerEnd(PointerUpEvent e) {
    final difference = _initialPosition - _positionRx.value;

    if (difference >= 100) {
      _initialPosition = -_mediaQueryPaddingTop;
      isFullScreen.value = true;
      _positionRx.value = -_mediaQueryPaddingTop;
    } else if (difference <= 100) {
      _initialPosition = _boardActualPosition;
      isFullScreen.value = false;
      _positionRx.value = _boardActualPosition;
    } else {
      _positionRx.value = _initialPosition;
    }

    _isResizableDragStart = false;
  }

  @override
  Widget build(BuildContext context) {
    final child = FCard(
      child: Column(
        children: [
          Listener(
            onPointerDown: _onPointerStart,
            onPointerMove: _onPointerMode,
            onPointerUp: _onPointerEnd,
            child: Material(
              color: Colors.transparent,
              child: ValueListenableBuilder(
                valueListenable: isFullScreen,
                builder: (
                  BuildContext context,
                  bool value,
                  Widget? child,
                ) {
                  return Padding(
                    padding: Pad(
                      all: 8,
                      bottom: 8,
                      top: value ? _mediaQueryPaddingTop + 8 : 0,
                    ),
                    child: const Center(
                      child: Material(
                        color: ThemePalette.black,
                        shape: StadiumBorder(),
                        child: SizedBox(
                          height: 4,
                          width: 64,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: widget.controller.state.boardObjects,
              builder: (
                BuildContext context,
                List<BoardItem<ProcessGameObject>> value,
                Widget? child,
              ) {
                final boardItems = GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  children: [
                    ...value.mapIndexed((i, e) {
                      return RepaintBoundary.wrap(
                        FCard(
                          child: Material(
                            color: Colors.transparent,
                            child: buildBoardCommonItemView(e),
                          ),
                        ),
                        i,
                      );
                    }),
                  ],
                );

                return ValueListenableBuilder(
                  valueListenable: activeDragging,
                  builder: (
                    BuildContext context,
                    value,
                    Widget? child,
                  ) {
                    return IgnorePointer(
                      ignoring: !value,
                      child: boardItems,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );

    return ValueListenableBuilder(
      valueListenable: widget.controller.flagExposer.renderBox,
      builder: (
        BuildContext context,
        RenderBox? value,
        Widget? child,
      ) {
        if (value == null || !value.attached) {
          return const SizedBox();
        }

        return ValueListenableBuilder(
          valueListenable: _positionRx,
          builder: (
            BuildContext context,
            double value,
            Widget? child,
          ) {
            return AnimatedPositioned(
              top: value + 24,
              left: 0,
              right: 0,
              bottom: 0,
              duration: const Duration(milliseconds: 80),
              child: child!,
            );
          },
          child: child,
        );
      },
      child: child,
    );
  }

  BoardItemWidget buildBoardCommonItemView(BoardItem e) {
    if (e.object is ColoredPart) {
      return BoardColoredPartWidget(
        controller: widget.controller,
        item: e,
      );
    }

    return BoardCommonItemWidget(
      item: e,
      flag: widget.flag,
      onDragUpdate: widget.onDragUpdate,
      onDragStarted: (ProcessGameObject object) {
        activeDragging.value = false;
        widget.onDragStarted?.call(object);
        if (isFullScreen.value) {
          closeFullScreen();
        }
      },
      onDraggableCanceled: widget.onDraggableCanceled,
      onDragCompleted: (ProcessGameObject object) {
        activeDragging.value = true;
        widget.onDragStarted?.call(object);
      },
      onDragEnd: (
        ProcessGameObject object,
        SDraggableDetails details,
      ) {
        activeDragging.value = true;
      },
      controller: widget.controller,
    );
  }

  void toggleDraggingStatus(bool value) {
    activeDragging.value = value;
  }
}
