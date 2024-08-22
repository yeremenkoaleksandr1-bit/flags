import 'package:add_to_cart_animation/globalkeyext.dart';
import 'package:drag_and_drop/extensions/render_box.dart';
import 'package:flags/domain/game_objects/base/game_object.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/selected_object/selected_object_cubit.dart';
import 'package:flags/uikit/game_widgets/objects/draggable_object.dart';
import 'package:flags/uikit/game_widgets/objects/game_object_paint.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditorDraggableWidget extends DraggableGameObjectWidget<GameObject> {
  EditorDraggableWidget(
    super.gameObject, {
    super.key,
  });

  @override
  State<EditorDraggableWidget> createState() => EditorDraggableWidgetState();
}

class EditorDraggableWidgetState
    extends DraggableGameObjectWidgetState<GameObject, EditorDraggableWidget> {
  final GlobalKey _paintedObjectKey = GlobalKey();

  late final selectedObjectCubit = context.read<EditorSelectedObjectCubit>();

  @override
  Alignment get rotateAlignment => Alignment.topLeft;

  Rect get paintBounds => context.globalPaintBounds!;

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
        ..scale(scale),
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
  void onMoveStart(DragStartDetails event, BoxConstraints constraints) {
    selectedObjectCubit.selectObject(widget);
    super.onMoveStart(event, constraints);
  }

  Offset startOffset = Offset.zero;
  Vector2 initialPosition = Vector2.zero();
  Vector2 initialSize = Vector2.zero();

  void onDragStart(DragStartDetails event) {
    startOffset = event.localPosition;
    initialPosition = positionRx.value;
    initialSize = sizeRx.value;
  }

  void onUpdateTopLeft(DragUpdateDetails event) {
    final delta = (event.localPosition - startOffset).toVector2();

    sizeRx.value = initialSize - delta;
    positionRx.value = initialPosition + delta;
  }

  @override
  Widget buildDraggableWidget(BuildContext context) {
    return CustomPaint(
      key: _paintedObjectKey,
      size: gameObject.size.toSize(),
      painter: GameObjectPainter(gameObject),
    );
  }
}
