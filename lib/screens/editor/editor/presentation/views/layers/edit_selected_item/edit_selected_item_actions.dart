import 'dart:math';

import 'package:community_material_icon/community_material_icon.dart';
import 'package:flags/screens/editor/editor/presentation/object_handles/editor_draggable.dart';
import 'package:flags/screens/editor/editor/presentation/object_handles/handle_button.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class EditSelectedItemActions extends StatefulWidget {
  const EditSelectedItemActions({
    super.key,
    required this.link,
    required this.fraction,
    required this.areaRect,
  });

  final EditorDraggableWidgetState link;
  final Rect areaRect;
  final double fraction;

  @override
  State<EditSelectedItemActions> createState() =>
      _EditSelectedItemActionsState();
}

class _EditSelectedItemActionsState extends State<EditSelectedItemActions> {
  EditorDraggableWidgetState get object => widget.link;

  double get fraction => widget.fraction;

  late Vector2 rectAreaPos = widget.areaRect.topLeft.toVector2();

  Vector2 startTapPos = Vector2.zero();
  Vector2 initialPosition = Vector2.zero();
  Vector2 initialSize = Vector2.zero();
  double initialRotation = 0;

  void onDragStart(DragStartDetails event) {
    initialRotatedPosition = object.paintBounds.topLeft.toVector2();
    startTapPos = event.globalPosition.toVector2();

    initialPosition = object.position.clone();
    initialSize = object.size.clone();
    initialRotation = object.rotation;
  }

  void onResize(DragUpdateDetails event, Vector2 pivot) {
    final angle = initialRotation;
    final Vector2 dragPos = event.globalPosition.toVector2();

    final Vector2 delta = (dragPos - startTapPos) / fraction;

    final rotatedDelta = _rotateVector(delta, -angle);
    final Vector2 newSize = initialSize + (rotatedDelta..multiply(pivot));

    object.size = newSize;

    final invertedPivot = Vector2(
      pivot.x == -1 ? 1 : (pivot.x == 1 ? 0 : pivot.x),
      pivot.y == -1 ? 1 : (pivot.y == 1 ? 0 : pivot.y),
    );

    final effectiveDelta = (pivot.y == -1 || pivot.x == -1)
        ? _rotateVector(rotatedDelta..multiply(invertedPivot), angle)
        : Vector2.zero();

    object.position = initialPosition - effectiveDelta;
  }

  void onUpdateTopLeft(DragUpdateDetails event) {
    onResize(event, Vector2(-1, -1));
  }

  void onUpdateTopRight(DragUpdateDetails event) {
    onResize(event, Vector2(1, -1));
  }

  void onUpdateBottomLeft(DragUpdateDetails event) {
    onResize(event, Vector2(-1, 1));
  }

  void onUpdateBottomRight(DragUpdateDetails event) {
    onResize(event, Vector2(1, 1));
  }

  void onUpdateCenterLeft(DragUpdateDetails event) {
    onResize(event, Vector2(-1, 0));
  }

  void onUpdateCenterRight(DragUpdateDetails event) {
    onResize(event, Vector2(1, 0));
  }

  void onUpdateTopCenter(DragUpdateDetails event) {
    onResize(event, Vector2(0, -1));
  }

  void onUpdateBottomCenter(DragUpdateDetails event) {
    onResize(event, Vector2(0, 1));
  }

  Vector2 initialRotatedPosition = Vector2.zero();

  void onRotationStart(DragStartDetails event) {
    initialRotatedPosition = object.paintBounds.topLeft.toVector2();

    startTapPos = event.globalPosition.toVector2();

    initialPosition = object.position;
    initialRotation = object.rotation;
  }

  void onUpdateRotation(DragUpdateDetails event) {
    final currentTap = event.globalPosition.toVector2();
    final center = initialRotatedPosition;

    final angleDelta = calculateAngle(center, startTapPos) -
        calculateAngle(center, currentTap);

    final double angle = initialRotation - angleDelta;

    final offset = object.size / 2;

    final rotatedOffset = (offset.clone()..rotate(angle)) -
        (offset.clone()..rotate(initialRotation));

    object.rotation = angle;

    object.position = initialPosition - rotatedOffset;
  }

  double calculateAngle(Vector2 initialPosition, Vector2 currentPosition) {
    final Vector2 delta = currentPosition - initialPosition;

    return atan2(delta.y, delta.x);
  }

  Vector2 _rotateVector(Vector2 vector, double angle) {
    final cosAngle = cos(angle);
    final sinAngle = sin(angle);
    return Vector2(
      vector.x * cosAngle - vector.y * sinAngle,
      vector.x * sinAngle + vector.y * cosAngle,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(),
          ),
          child: LayoutBuilder(
            builder: (
              BuildContext context,
              BoxConstraints constraints,
            ) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    bottom: -9 - 24 - 24,
                    right: -9 + constraints.maxWidth / 2,
                    child: EOHandleButton(
                      onDragUpdate: onUpdateRotation,
                      onDragStart: onRotationStart,
                      borderRadiusCircular: 24,
                      onDragEnd: (DragEndDetails event) {},
                      child: const SizedBox.shrink(),
                    ),
                  ),
                  Positioned(
                    top: -9,
                    left: -9,
                    child: EOHandleButton(
                      onDragUpdate: onUpdateTopLeft,
                      onDragStart: onDragStart,
                      onDragEnd: (DragEndDetails event) {},
                      child: const SizedBox.shrink(),
                    ),
                  ),
                  Positioned(
                    top: -9,
                    left: -9 + constraints.maxWidth / 2,
                    child: EOHandleButton(
                      onDragUpdate: onUpdateTopCenter,
                      onDragStart: onDragStart,
                      onDragEnd: (DragEndDetails event) {},
                      child: const SizedBox.shrink(),
                    ),
                  ),
                  Positioned(
                    top: -9,
                    right: -9,
                    child: EOHandleButton(
                      onDragUpdate: onUpdateTopRight,
                      onDragStart: onDragStart,
                      onDragEnd: (DragEndDetails event) {},
                      child: const SizedBox.shrink(),
                    ),
                  ),
                  Positioned(
                    top: -9 + constraints.maxHeight / 2,
                    right: -9,
                    child: EOHandleButton(
                      onDragUpdate: onUpdateCenterRight,
                      onDragStart: onDragStart,
                      onDragEnd: (DragEndDetails event) {},
                      child: const SizedBox.shrink(),
                    ),
                  ),
                  Positioned(
                    bottom: -9,
                    left: -9,
                    child: EOHandleButton(
                      onDragUpdate: onUpdateBottomLeft,
                      onDragStart: onDragStart,
                      onDragEnd: (DragEndDetails event) {},
                      child: const SizedBox.shrink(),
                    ),
                  ),
                  Positioned(
                    bottom: -9,
                    left: -9 + constraints.maxWidth / 2,
                    child: EOHandleButton(
                      onDragUpdate: onUpdateBottomCenter,
                      onDragStart: onDragStart,
                      onDragEnd: (DragEndDetails event) {},
                      child: const SizedBox.shrink(),
                    ),
                  ),
                  Positioned(
                    bottom: -9,
                    right: -9,
                    child: EOHandleButton(
                      onDragUpdate: onUpdateBottomRight,
                      onDragStart: onDragStart,
                      onDragEnd: (DragEndDetails event) {},
                      child: const SizedBox.shrink(),
                    ),
                  ),
                  Positioned(
                    top: -9 + constraints.maxHeight / 2,
                    left: -9,
                    child: EOHandleButton(
                      onDragUpdate: onUpdateCenterLeft,
                      onDragStart: onDragStart,
                      onDragEnd: (DragEndDetails event) {},
                      child: const SizedBox.shrink(),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
