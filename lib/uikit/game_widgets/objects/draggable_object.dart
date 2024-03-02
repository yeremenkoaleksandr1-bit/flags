import 'package:defer_pointer/defer_pointer.dart';
import 'package:flags/domain/game_objects/game_objects.dart';
import 'package:flags/uikit/game_widgets/game_widgets.dart';
import 'package:flags/uikit/utils/render_box_exposed.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:gesture_x_detector/gesture_x_detector.dart';

typedef DraggableMovableDataCallback = void Function(
  DraggableGameObjectState state,
  Vector2 position,
);

class DraggableGameObject<G extends GameObject> extends GameObjectWidget<G> {
  const DraggableGameObject(
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
  State<DraggableGameObject<G>> createState() => DraggableGameObjectState();
}

class DraggableGameObjectState<G extends GameObject,
    T extends DraggableGameObject<G>> extends GameObjectWidgetState<G, T> {
  final RenderBoxExposer exposer = RenderBoxExposer();

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

  late Vector2 _startPosition = Vector2.zero();

  @mustCallSuper
  void onMoveStart(MoveEvent event, BoxConstraints constraints) {
    _startPosition = MatrixUtils.transformPoint(
      Matrix4.identity()
        ..rotateZ(
          -rotationRx.value,
        ),
      event.position,
    ).toVector2();

    widget.onMoveStart?.call(this, _startPosition);
  }

  @mustCallSuper
  void onMoveUpdate(MoveEvent event, BoxConstraints constraints) {
    final localPosition =
        areaRenderBox.globalToLocal(event.position).toVector2();

    final test = MatrixUtils.transformPoint(
      Matrix4.rotationZ(-rotationRx.value),
      (localPosition - _startPosition).toOffset(),
    );

    positionRx.value = test.toVector2();

    // positionRx.value = (event.position - _startPosition).toVector2();
    widget.onMoveUpdate?.call(this, test.toVector2());
  }

  @mustCallSuper
  void onMoveEnd(MoveEvent event, BoxConstraints constraints) {
    widget.onMoveEnd?.call(this, event.position.toVector2());
  }

  Widget buildDraggableWidget(BuildContext context) {
    return super.buildWidget(context);
  }

  @override
  Widget buildWidget(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final transform = Matrix4.identity()
          ..translate(constraints.maxWidth / 2, constraints.maxHeight / 2)
          ..rotateZ(
            rotationRx.value,
          )
          ..translate(-constraints.maxWidth / 2, -constraints.maxHeight / 2);

        final rect = MatrixUtils.transformRect(
          transform,
          constraints.biggest.toRect(),
        );

        return DeferPointer(
          child: Transform(
            transform: transform,
            child: XGestureDetector(
              onMoveStart: (e) => onMoveStart(e, constraints),
              onMoveUpdate: (e) => onMoveUpdate(e, constraints),
              onMoveEnd: (e) => onMoveEnd(e, constraints),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: rect.width,
                    maxHeight: rect.height,
                  ),
                  child: buildDraggableWidget(context),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
