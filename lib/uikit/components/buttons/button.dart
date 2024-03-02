import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/widgets.dart';

import '../../assets/components/button.dart';
import '../gestures/scaled_gesture.dart';

class FButton extends StatelessWidget {
  const FButton({
    super.key,
    required this.color,
    required this.onPressed,
    required this.child,
  });

  final Color color;
  final VoidCallback onPressed;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ScaledGestureDetector(
      onTap: onPressed,
      child: AButtonWidget(
        color: color,
        child: Padding(
          padding: const Pad(all: 8),
          child: child,
        ),
      ),
    );
  }
}
