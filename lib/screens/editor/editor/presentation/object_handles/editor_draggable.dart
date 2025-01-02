import 'dart:math';

import 'package:drag_and_drop/extensions/render_box.dart';
import 'package:flags/domain/game_objects/base/game_object.dart';
import 'package:flags/screens/editor/editor/custom_defer_pointer/defer_pointer.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/area/area_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/magnet_area/magnet_area_cubit.dart';
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
  late final MagnetAreaCubit magnetCubit = context.read<MagnetAreaCubit>();
  late final EditorAreaCubit areaCubit = context.read<EditorAreaCubit>();

  final GlobalKey paintedObjectKey = GlobalKey();

  late final selectedObjectCubit = context.read<EditorSelectedObjectCubit>();

  @override
  Alignment get rotateAlignment => Alignment.topLeft;

  Rect get paintBounds => paintedObjectKey.currentContext!.globalPaintBounds!;

  @override
  Rect transformRect({
    required Vector2 position,
    required Vector2 size,
    required double rotation,
    required double scale,
  }) {
    return MatrixUtils.transformRect(
      Matrix4.identity()
        ..translate(
          position.x,
          position.y,
        )
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
  void onMoveStart(event, BoxConstraints constraints) {
    selectedObjectCubit.selectObject(widget);
    super.onMoveStart(event, constraints);
  }

  Offset startOffset = Offset.zero;
  Vector2 initialPosition = Vector2.zero();
  Vector2 initialSize = Vector2.zero();

  void onDragStart(DragStartDetails event) {
    startOffset = event.localPosition;
    initialPosition = gameObject.position;
    initialSize = gameObject.size;
  }

  void onUpdateTopLeft(event) {
    final delta = (event.localPosition - startOffset).toVector2();

    gameObject.size = initialSize - delta;
    gameObject.position = initialPosition + delta;
  }

  bool hasSnapping = false;

  @override
  void onMoveEnd(event, BoxConstraints constraints) {
    magnetCubit.setActiveHorizontalPosition(false);
    magnetCubit.setActiveVerticalPosition(false);
    hasSnapping = false;

    super.onMoveEnd(event, constraints);
  }

  @override
  Size get areaSize => areaCubit.state.rect.size / areaCubit.fraction;

  @override
  void onMoveUpdate(DragUpdateDetails event, BoxConstraints constraints) {
    hasSnapping = false;
    final localPosition =
        areaRenderBox.globalToLocal(event.globalPosition).toVector2();

    var newPosition = localPosition - startPosition;

    if (magnetCubit.state.active) {
      final objectCenter = newPosition + gameObject.size / 2;
      final areaSize = areaCubit.state.rect.size / areaCubit.fraction;

      final offset = gameObject.size / 2;

      final rotatedOffset = (offset.clone()..rotate(0)) -
          (offset.clone()..rotate(gameObject.rotation));

      final isSnapVertical =
          (objectCenter.x - areaSize.width / 2 - rotatedOffset.x).abs() < 5;
      final isSnapHorizontal =
          (objectCenter.y - areaSize.height / 2 - rotatedOffset.y).abs() < 5;

      if (isSnapVertical) {
        hasSnapping = true;
        newPosition = Vector2(
          areaSize.width / 2 - gameObject.size.x / 2 + rotatedOffset.x,
          newPosition.y,
        );
        magnetCubit.setActiveVerticalPosition(true);
      }

      if (isSnapHorizontal) {
        hasSnapping = true;
        newPosition = Vector2(
          newPosition.x,
          areaSize.height / 2 - gameObject.size.y / 2 + rotatedOffset.y,
        );
        magnetCubit.setActiveHorizontalPosition(true);
      }
    }
    final rotatedPoints = [
      Vector2(0, 0),
      Vector2(gameObject.size.x, 0),
      Vector2(gameObject.size.x, gameObject.size.y),
      Vector2(0, gameObject.size.y),
    ].map((point) {
      final rotatedPoint = point.clone()
        ..rotate(gameObject.rotation)
        ..add(newPosition);
      return rotatedPoint;
    }).toList();

    final minX = rotatedPoints.map((p) => p.x).reduce((a, b) => a < b ? a : b);
    final maxX = rotatedPoints.map((p) => p.x).reduce((a, b) => a > b ? a : b);
    final minY = rotatedPoints.map((p) => p.y).reduce((a, b) => a < b ? a : b);
    final maxY = rotatedPoints.map((p) => p.y).reduce((a, b) => a > b ? a : b);

    if (maxX < 0 ||
        maxY < 0 ||
        minX > areaSize.width ||
        minY > areaSize.height) {
      // final areaCenter = Vector2(areaSize.width / 2, areaSize.height / 2);
      //
      // final objectCenterOffset =
      //     Vector2(gameObject.size.x / 2, gameObject.size.y / 2)
      //       ..rotate(gameObject.rotation);
      //
      // gameObject.position = areaCenter - objectCenterOffset;

      return;
    }

    gameObject.position = newPosition;
  }

  Vector2 calculateRotatedOffset(Vector2 size, double rotation) {
    final radians = rotation * (pi / 180);

    final offsetX = size.x / 2 * cos(radians) - size.y / 2 * sin(radians);
    final offsetY = size.x / 2 * sin(radians) + size.y / 2 * cos(radians);

    return Vector2(offsetX, offsetY);
  }

  @override
  void dispose() {
    gameObject.dispose();
    super.dispose();
  }

  @override
  Widget buildWidget(BuildContext context, GameObject gameObject) {
    return KeyedSubtree(
      key: paintedObjectKey,
      child: EDeferPointer(
        child: super.buildWidget(context, gameObject),
      ),
    );
  }

  @override
  Widget buildDraggableWidget(BuildContext context, GameObject gameObject) {
    return CustomPaint(
      size: gameObject.size.toSize(),
      painter: GameObjectPainter(gameObject),
    );
  }
}
