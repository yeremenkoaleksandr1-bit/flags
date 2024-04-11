// ignore_for_file: no_logic_in_create_state

import 'package:armar/armar.dart';
import 'package:armar/rx/rx.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
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

class PartsBoard extends StatefulWidget {
  const PartsBoard({
    super.key,
    required this.presenter,
    required this.flag,
    this.onDragStarted,
    this.onDragUpdate,
    this.onDraggableCanceled,
    this.onDragEnd,
    this.onDragCompleted,
  });

  final GameFlag flag;
  final IPuzzleCommonModePresenter presenter;

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
  State<PartsBoard> createState() => presenter.boardController;
}

class PartsBoardState extends State<PartsBoard> {
  RxValue<bool> activeDragging = RxValue(true);
  RxValue<bool> isFullScreen = RxValue(false);

  final RxValue<double> _positionRx = RxValue(0.0);

  double _boardActualPosition = 0;
  late final _mediaQueryPaddingTop = context.mediaQueryPadding.top;

  @override
  void initState() {
    FlutterEngine.schedulePostFrameCallback((timeStamp) {
      widget.presenter.flagExposer.renderBox.stream.listen((event) {
        if (event != null) {
          try {
            isFullScreen.value = false;
            _positionRx.value = event.rect.bottom;
            _boardActualPosition = _positionRx.value;
          } catch (e) {}
        }
      });
    });
    super.initState();
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
              child: FastBuilder(
                () {
                  final isFullScreen = this.isFullScreen.value;
                  return Padding(
                    padding: Pad(
                      all: 8,
                      bottom: 8,
                      top: isFullScreen ? _mediaQueryPaddingTop + 8 : 0,
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
            child: FastValueBuilder(
              listen: widget.presenter.state.boardObjects,
              builder: (Iterable<BoardItem> objects) {
                final boardItems = GridView.count(
                  crossAxisCount: 4,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  children: [
                    ...objects.mapIndexed((e, i) {
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

                return FastValueBuilder(
                  listen: activeDragging,
                  builder: (bool value) {
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

    return FastValueBuilder(
      listen: widget.presenter.flagExposer.renderBox,
      builder: (RenderBox? value) {
        if (value == null || !value.attached) {
          return const SizedBox();
        }

        final position = _positionRx.value;

        return AnimatedPositioned(
          top: position + 24,
          left: 0,
          right: 0,
          bottom: 0,
          duration: const Duration(milliseconds: 80),
          child: child,
        );
      },
    );
  }

  BoardItemWidget buildBoardCommonItemView(BoardItem e) {
    if (e.object is ColoredPart) {
      return BoardColoredPartWidget(
        presenter: widget.presenter,
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
      presenter: widget.presenter,
    );
  }

  void toggleDraggingStatus(bool value) {
    activeDragging.value = value;
  }
}
