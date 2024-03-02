import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import 'draggable.dart';

class SLongPressDraggable<T extends Object> extends SDraggable<T> {
  const SLongPressDraggable({
    super.key,
    required super.child,
    required super.feedbackBuilder,
    super.data,
    super.childWhenDragging,
    required super.feedbackRect,
    super.dragAnchorStrategy,
    super.maxSimultaneousDrags,
    super.onDragStarted,
    super.onDragUpdate,
    super.onDraggableCanceled,
    super.onDragEnd,
    super.onDragCompleted,
    this.hapticFeedbackOnStart = true,
    super.ignoringFeedbackSemantics,
    super.ignoringFeedbackPointer,
    this.delay = kLongPressTimeout,
    super.allowedButtonsFilter,
    super.animationDuration = const Duration(milliseconds: 150),
    super.animationReverseDuration = const Duration(milliseconds: 150),
  });

  final bool hapticFeedbackOnStart;

  final Duration delay;

  @override
  DelayedMultiDragGestureRecognizer createRecognizer(
    GestureMultiDragStartCallback onStart,
  ) {
    return DelayedMultiDragGestureRecognizer(
      delay: delay,
      allowedButtonsFilter: allowedButtonsFilter,
    )..onStart = (Offset position) {
        final Drag? result = onStart(position);
        if (result != null && hapticFeedbackOnStart) {
          HapticFeedback.selectionClick();
        }
        return result;
      };
  }
}
