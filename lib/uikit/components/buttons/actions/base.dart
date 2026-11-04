import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flutter/cupertino.dart';

abstract class FActionButton extends StatelessWidget {
  final VoidCallback? onTap;
  final Duration? duration;

  const FActionButton({
    super.key,
    this.onTap,
    this.duration,
  });

  Widget buildWidget(BuildContext context);

  @override
  @protected
  Widget build(BuildContext context) {
    return ScaledGestureDetector(
      onTap: onTap,
      duration: duration,
      child: buildWidget(context),
    );
  }
}
