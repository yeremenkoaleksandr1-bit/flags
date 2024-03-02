import 'package:defer_pointer/defer_pointer.dart';
import 'package:flags/domain/game_objects/game_objects.dart';
import 'package:flags/uikit/game_widgets/game_widgets.dart';
import 'package:flags/uikit/utils/render_box_exposed.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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

  late Vector2 _startPosition = Vector2.zero();

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
                () => PanGestureRecognizer(),
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
