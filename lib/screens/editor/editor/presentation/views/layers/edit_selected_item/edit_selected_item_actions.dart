import 'dart:async';
import 'dart:math';

import 'package:flags/domain/game_objects/base/game_object.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/area/area_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/magnet_area/magnet_area_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/object_handles/editor_draggable.dart';
import 'package:flags/screens/editor/editor/presentation/object_handles/handle_button.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  late final MagnetAreaCubit magnetCubit = context.read<MagnetAreaCubit>();
  late final EditorAreaCubit areaCubit = context.read<EditorAreaCubit>();

  GameObject get object => widget.link.gameObject;

  double get fraction => widget.fraction;

  late Vector2 rectAreaPos = widget.areaRect.topLeft.toVector2();

  Vector2 startTapPos = Vector2.zero();
  Vector2 initialPosition = Vector2.zero();
  Vector2 initialSize = Vector2.zero();
  double initialRotation = 0;

  bool isProportionalResizing = true;
  Timer? longPressTimer;
  Offset lastDragPosition = Offset.zero;
  final double movementThreshold = 5.0;

  void onDragStart(DragStartDetails event) {
    initialRotatedPosition = widget.link.paintBounds.topLeft.toVector2();
    startTapPos = event.globalPosition.toVector2();

    initialPosition = object.position.clone();
    initialSize = object.size.clone();
    initialRotation = object.rotation;

    isProportionalResizing = true;
    lastDragPosition = event.globalPosition;

    longPressTimer = Timer(const Duration(milliseconds: 500), () {
      isProportionalResizing = false;

      HapticFeedback.lightImpact();
    });
  }

  late final double aspectRatio = object.originalSize.x / object.originalSize.y;

  void onDragEnd(DragEndDetails event) {
    longPressTimer?.cancel();
  }

  //Todo: do refactoring
  void onResize(DragUpdateDetails event, Vector2 pivot) {
    if ((lastDragPosition - event.globalPosition).distance != 0) {
      longPressTimer?.cancel();

      final angle = initialRotation;
      final Vector2 dragPos = event.globalPosition.toVector2();
      final Vector2 delta = (dragPos - startTapPos) / fraction;
      final Vector2 rotatedDelta = _rotateVector(delta, -angle);

      Vector2 newSize = initialSize + (rotatedDelta..multiply(pivot));

      newSize = Vector2(
        max(newSize.x, 1),
        max(newSize.y, 1),
      );

      if (isProportionalResizing) {
        if (pivot.x == 1 && pivot.y == 1) {
          newSize = Vector2(
            newSize.x,
            newSize.x / aspectRatio,
          );
        }

        if (pivot.x == 1 && pivot.y == 0) {
          newSize = Vector2(
            newSize.x,
            newSize.x / aspectRatio,
          );
        }

        if (pivot.x == 1 && pivot.y == -1) {
          newSize = Vector2(
            newSize.y * aspectRatio,
            newSize.y,
          );
        }

        if (pivot.x == 0 && pivot.y == 1) {
          newSize = Vector2(
            newSize.y,
            newSize.y / aspectRatio,
          );
        }

        if (pivot.x == 0 && pivot.y == -1) {
          newSize = Vector2(
            newSize.y * aspectRatio,
            newSize.y,
          );
        }

        if (pivot.x == -1 && pivot.y == 1) {
          newSize = Vector2(
            newSize.x * aspectRatio,
            newSize.x,
          );
        }

        if (pivot.x == -1 && pivot.y == 0) {
          newSize = Vector2(
            newSize.x * aspectRatio,
            newSize.x,
          );
        }

        if (pivot.x == -1 && pivot.y == -1) {
          newSize = Vector2(
            newSize.x,
            newSize.x / aspectRatio,
          );
        }
      }

      object.size = newSize;

      final Vector2 invertedPivot = Vector2(
        pivot.x == -1 ? 1 : (pivot.x == 1 ? 0 : pivot.x),
        pivot.y == -1 ? 1 : (pivot.y == 1 ? 0 : pivot.y),
      );

      if (newSize.x > 1 && newSize.y > 1) {
        if (pivot.x == -1 && pivot.y == -1) {
          object.position = initialPosition -
              _rotateVector(
                Vector2(rotatedDelta.x, rotatedDelta.x)
                  ..multiply(invertedPivot),
                angle,
              );
        } else {
          final Vector2 effectiveDelta = (pivot.y == -1 || pivot.x == -1)
              ? _rotateVector(rotatedDelta..multiply(invertedPivot), angle)
              : Vector2.zero();

          object.position = initialPosition - effectiveDelta;
        }
      }
    }
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
    initialRotatedPosition = widget.link.paintBounds.center.toVector2();

    startTapPos = event.globalPosition.toVector2();

    initialPosition = object.position;
    initialRotation = object.rotation;
  }

  void onUpdateRotation(DragUpdateDetails event) {
    final currentTap = event.globalPosition.toVector2();
    final center = initialRotatedPosition;

    final currentAngle = calculateAngle(center, currentTap);
    final startAngle = calculateAngle(center, startTapPos);

    double angleDelta = currentAngle - startAngle;

    if (angleDelta < -pi) {
      angleDelta += 2 * pi;
    } else if (angleDelta > pi) {
      angleDelta -= 2 * pi;
    }

    double newRotation = (initialRotation + angleDelta).remainder(2 * pi);
    if (newRotation < 0) {
      newRotation += 2 * pi;
    }

    final snapInterval = (magnetCubit.state.active ? 45.0 : 1) * (pi / 180.0);

    final double snappedAngle =
        (newRotation / snapInterval).round() * snapInterval;

    if (magnetCubit.state.active) {
      if (snappedAngle != object.rotation) {
        //TODO: something
      }
    }

    object.rotation = snappedAngle;

    final offset = object.size / 2;

    final rotatedOffset = (offset.clone()..rotate(snappedAngle)) -
        (offset.clone()..rotate(initialRotation));

    object.position = initialPosition - rotatedOffset;
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
      fit: StackFit.passthrough,
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
                fit: StackFit.expand,
                children: [
                  Positioned(
                    bottom: -9 - 24 - 24,
                    right: -9 + constraints.maxWidth / 2,
                    child: EOHandleButton(
                      onDragUpdate: onUpdateRotation,
                      onDragStart: onRotationStart,
                      borderRadiusCircular: 24,
                      onDragEnd: onDragEnd,
                      child: const SizedBox.shrink(),
                    ),
                  ),
                  Positioned(
                    top: -9,
                    left: -9,
                    child: EOHandleButton(
                      onDragUpdate: onUpdateTopLeft,
                      onDragStart: onDragStart,
                      onDragEnd: onDragEnd,
                      child: const SizedBox.shrink(),
                    ),
                  ),
                  Positioned(
                    top: -9,
                    left: -9 + constraints.maxWidth / 2,
                    child: EOHandleButton(
                      onDragUpdate: onUpdateTopCenter,
                      onDragStart: onDragStart,
                      onDragEnd: onDragEnd,
                      child: const SizedBox.shrink(),
                    ),
                  ),
                  Positioned(
                    top: -9,
                    right: -9,
                    child: EOHandleButton(
                      onDragUpdate: onUpdateTopRight,
                      onDragStart: onDragStart,
                      onDragEnd: onDragEnd,
                      child: const SizedBox.shrink(),
                    ),
                  ),
                  Positioned(
                    top: -9 + constraints.maxHeight / 2,
                    right: -9,
                    child: EOHandleButton(
                      onDragUpdate: onUpdateCenterRight,
                      onDragStart: onDragStart,
                      onDragEnd: onDragEnd,
                      child: const SizedBox.shrink(),
                    ),
                  ),
                  Positioned(
                    bottom: -9,
                    left: -9,
                    child: EOHandleButton(
                      onDragUpdate: onUpdateBottomLeft,
                      onDragStart: onDragStart,
                      onDragEnd: onDragEnd,
                      child: const SizedBox.shrink(),
                    ),
                  ),
                  Positioned(
                    bottom: -9,
                    left: -9 + constraints.maxWidth / 2,
                    child: EOHandleButton(
                      onDragUpdate: onUpdateBottomCenter,
                      onDragStart: onDragStart,
                      onDragEnd: onDragEnd,
                      child: const SizedBox.shrink(),
                    ),
                  ),
                  Positioned(
                    bottom: -9,
                    right: -9,
                    child: EOHandleButton(
                      onDragUpdate: onUpdateBottomRight,
                      onDragStart: onDragStart,
                      onDragEnd: onDragEnd,
                      child: const SizedBox.shrink(),
                    ),
                  ),
                  Positioned(
                    top: -9 + constraints.maxHeight / 2,
                    left: -9,
                    child: EOHandleButton(
                      onDragUpdate: onUpdateCenterLeft,
                      onDragStart: onDragStart,
                      onDragEnd: onDragEnd,
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

double calculateAngle(Vector2 center, Vector2 point) {
  return atan2(point.y - center.y, point.x - center.x);
}
