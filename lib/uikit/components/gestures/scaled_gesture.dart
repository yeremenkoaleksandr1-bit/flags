import 'package:flutter/material.dart';

import '../../../ui/notifications/tap_button_notification.dart';

class ScaledGestureDetector extends StatefulWidget {
  const ScaledGestureDetector({
    super.key,
    this.onTap,
    required this.child,
    this.duration,
  });

  final GestureTapCallback? onTap;

  final Duration? duration;

  final Widget child;

  @override
  State<ScaledGestureDetector> createState() => _ScaledGestureDetectorState();
}

class _ScaledGestureDetectorState extends State<ScaledGestureDetector>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  bool get isDisabled => widget.onTap == null;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: widget.duration ?? const Duration(milliseconds: 100),
    );

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void onPointerDown() {
    if (!isDisabled) {
      _animationController.forward(from: _animationController.value);
    }
  }

  void onPointerUp() {
    if (!isDisabled) {
      widget.onTap?.call();
      context.dispatchNotification(const TapButtonNotification());
      onPointerCancel();
    }
  }

  void onPointerCancel() {
    if (!isDisabled) {
      _animationController.reverse(from: _animationController.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => onPointerDown(),
      onTapCancel: () => onPointerCancel(),
      onTapUp: (_) => onPointerUp(),
      child: Builder(builder: (context) {
        return AnimatedBuilder(
          animation: _animationController,
          builder: (BuildContext context, Widget? child) {
            final value = _animationController.value;

            return Transform.scale(
              scale: 1 - (0.05 * Curves.easeInBack.transform(value)),
              child: child!,
            );
          },
          child: widget.child,
        );
      }),
    );
  }

  void onTap() {
    if (!isDisabled) {
      widget.onTap?.call();
    }
  }
}
