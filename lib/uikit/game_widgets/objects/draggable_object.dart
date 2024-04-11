import 'dart:math';

import 'package:defer_pointer/defer_pointer.dart';
import 'package:flags/domain/game_objects/game_objects.dart';
import 'package:flags/uikit/game_widgets/game_widgets.dart';
import 'package:flags/uikit/utils/render_box_exposed.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

typedef DraggableMovableDataCallback = void Function(
  DraggableGameObjectWidgetState state,
  Vector2 position,
);

class DraggableGameObjectWidget<G extends GameObject>
    extends GameObjectWidget<G> {
  const DraggableGameObjectWidget(
    super.gameObject, {
    super.key,
    this.onRenderBoxChanged,
    this.onMoveStart,
    this.onMoveUpdate,
    this.onMoveEnd,
  });

  final DraggableMovableDataCallback? onMoveStart;
  final DraggableMovableDataCallback? onMoveUpdate;
  final DraggableMovableDataCallback? onMoveEnd;

  final void Function(RenderBox renderBox)? onRenderBoxChanged;

  @override
  State<DraggableGameObjectWidget<G>> createState() =>
      DraggableGameObjectWidgetState();
}

class DraggableGameObjectWidgetState<G extends GameObject,
        T extends DraggableGameObjectWidget<G>>
    extends GameObjectWidgetState<G, T> {
  final RenderBoxExposer exposer = RenderBoxExposer();

  late Vector2 _startPosition = Vector2.zero();

  @override
  Rect transformRect({
    required Vector2 position,
    required Vector2 size,
    required double rotation,
    required double scale,
  }) {
    return MatrixUtils.transformRect(
      Matrix4.identity()
        ..translate(position.x, position.y)
        ..translate(size.x / 2, size.y / 2)
        ..scale(scale)
        ..translate(-size.x / 2, -size.y / 2),
      Vector2.zero() & size,
    );
  }

  @override
  Matrix4 transformationMatrix({
    required Vector2 position,
    required Vector2 size,
    required double rotation,
    required double scale,
  }) {
    return Matrix4.identity();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.onRenderBoxChanged != null) {
        exposer.renderBox.stream.listen((event) {
          if (event != null) {
            widget.onRenderBoxChanged!.call(event);
          }
        });
      }
    });
  }

  @mustCallSuper
  void onMoveStart(DragStartDetails event, BoxConstraints constraints) {
    final localPosition =
        areaRenderBox.globalToLocal(event.globalPosition).toVector2();
    _startPosition = localPosition - positionRx.value;
    widget.onMoveStart?.call(this, localPosition);
  }

  @mustCallSuper
  void onMoveUpdate(DragUpdateDetails event, BoxConstraints constraints) {
    final localPosition =
        areaRenderBox.globalToLocal(event.globalPosition).toVector2();
    final newPosition = localPosition - _startPosition;
    positionRx.value = newPosition;
    widget.onMoveUpdate?.call(this, newPosition);
  }

  @mustCallSuper
  void onMoveEnd(DragEndDetails event, BoxConstraints constraints) {
    widget.onMoveEnd?.call(this, positionRx.value);
  }

  Widget buildDraggableWidget(BuildContext context) {
    return super.buildWidget(context);
  }

  @override
  Widget buildWidget(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return DeferPointer(
          child: RawGestureDetector(
            gestures: {
              PanGestureRecognizer:
                  GestureRecognizerFactoryWithHandlers<PanGestureRecognizer>(
                PanGestureRecognizer.new,
                (i) {
                  i.onStart = (event) => onMoveStart(event, constraints);
                  i.onUpdate = (event) => onMoveUpdate(event, constraints);
                  i.onEnd = (event) => onMoveEnd(event, constraints);
                },
              ),
            },
            behavior: HitTestBehavior.translucent,
            child: buildDraggableWidget(context),
          ),
        );
      },
    );
  }
}
