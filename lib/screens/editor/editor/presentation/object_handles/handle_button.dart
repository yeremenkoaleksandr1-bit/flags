import 'package:defer_pointer/defer_pointer.dart';
import 'package:flags/screens/editor/editor/custom_defer_pointer/defer_pointer.dart';
import 'package:flags/screens/editor/editor/layers.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class EOHandleButton extends StatefulWidget {
  const EOHandleButton({
    super.key,
    required this.child,
    required this.onDragUpdate,
    required this.onDragStart,
    required this.onDragEnd,
    this.borderRadiusCircular = 24,
  });

  final Widget child;
  final void Function(DragUpdateDetails event) onDragUpdate;
  final void Function(DragStartDetails event) onDragStart;
  final void Function(DragEndDetails event) onDragEnd;

  final double borderRadiusCircular;

  @override
  State<EOHandleButton> createState() => _EOHandleButtonState();
}

class _EOHandleButtonState extends State<EOHandleButton> {
  final ValueNotifier<bool> selectListener = ValueNotifier(false);

  void onDragStart(DragStartDetails event) {
    selectListener.value = true;
    widget.onDragStart(event);
  }

  void onDragUpdate(DragUpdateDetails event) {
    widget.onDragUpdate(event);
  }

  void onDragEnd(DragEndDetails event) {
    selectListener.value = false;
    widget.onDragEnd(event);
  }

  @override
  void dispose() {
    selectListener.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EDeferPointer(
      child: RawGestureDetector(
        gestures: {
          PanGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<PanGestureRecognizer>(
            PanGestureRecognizer.new,
            (i) {
              i.onStart = onDragStart;
              i.onUpdate = onDragUpdate;
              i.onEnd = onDragEnd;
            },
          ),
        },
        behavior: HitTestBehavior.translucent,
        child: ValueListenableBuilder(
          valueListenable: selectListener,
          builder: (
            BuildContext context,
            bool value,
            Widget? child,
          ) {
            return Material(
              shape: RoundedRectangleBorder(
                side: const BorderSide(),
                borderRadius: BorderRadius.all(
                  Radius.circular(widget.borderRadiusCircular),
                ),
              ),
              color: value ? ThemePalette.blueButton : ThemePalette.white,
              child: child,
            );
          },
          child: SizedBox.square(
            dimension: 18,
            child: Center(child: widget.child),
          ),
        ),
      ),
    );
  }
}
