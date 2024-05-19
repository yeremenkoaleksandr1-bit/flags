import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/uikit/assets/components/button.dart';
import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flutter/widgets.dart';

class FButton extends StatelessWidget {
  const FButton({
    super.key,
    required this.color,
    required this.onPressed,
    required this.child,
    this.onLongPress,
  });

  final Color color;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: ScaledGestureDetector(
        onTap: onPressed,
        onLongPress: onLongPress,
        child: AButtonWidget(
          color: color,
          child: Padding(
            padding: const Pad(all: 8),
            child: child,
          ),
        ),
      ),
    );
  }
}
