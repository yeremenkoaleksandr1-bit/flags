import 'dart:async';

import 'package:flags/core/features/overlay/overlay_mixin.dart';
import 'package:flags/uikit/drag_and_drop/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class DragWidget<T> extends StatefulWidget {
  const DragWidget({
    super.key,
    required this.builder,
    this.onDragStart,
    this.onDragUpdated,
    this.onDragEnd,
    this.onTap,
    this.onLongPress,
    this.longPressDuration,
  });

  final WidgetBuilder builder;

  final FutureOr<void> Function()? onTap;
  final FutureOr<void> Function()? onLongPress;

  final Duration? longPressDuration;

  final FutureOr<void> Function(Offset position)? onDragStart;
  final FutureOr<void> Function(Offset position)? onDragUpdated;
  final FutureOr<void> Function(Offset position)? onDragEnd;

  @override
  State<DragWidget<T>> createState() => _DragWidgetState<T>();
}

class _DragWidgetState<T> extends State<DragWidget<T>> with OverlayStateMixin {
  late final IDragAndDropProvider provider = IDragAndDropProvider.of(context);

  final ValueNotifier<bool> isDragged = ValueNotifier(false);

  void onPointerDown() {
    showOverlay();
  }

  void onPointerUp() {
    removeOverlay();
  }

  void onPointerCancel() {
    removeOverlay();
  }

  @override
  void dispose() {
    isDragged.dispose();
    super.dispose();
  }

  late final child = widget.builder(context);

  @override
  Widget build(BuildContext context) {
    return RawGestureDetector(
      gestures: gestures,
      child: ValueListenableBuilder(
        valueListenable: isDragged,
        builder: (
          BuildContext context,
          bool value,
          Widget? child,
        ) {
          return child!;
        },
        child: child,
      ),
    );
  }

  late final Map<Type, GestureRecognizerFactory<GestureRecognizer>> gestures = {
    TapGestureRecognizer:
        GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
      TapGestureRecognizer.new,
      tapRecognizer,
    ),
    if (widget.onLongPress != null)
      LongPressGestureRecognizer:
          GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
        () => LongPressGestureRecognizer(
          duration: widget.longPressDuration,
        ),
        longPressRecognizer,
      ),
  };

  void longPressRecognizer(LongPressGestureRecognizer recognizer) {
    recognizer.onLongPress = widget.onLongPress;
  }

  void tapRecognizer(TapGestureRecognizer recognizer) {
    if (!mounted) {
      return;
    }

    recognizer.onTapDown = (e) => onPointerDown();
    recognizer.onTapUp = (e) => onPointerUp();
    recognizer.onTapCancel = onPointerCancel;
  }

  @override
  Widget buildOverlay(BuildContext context, Rect rect) {
    return RepaintBoundary(
      child: widget.builder(context),
    );
  }
}
