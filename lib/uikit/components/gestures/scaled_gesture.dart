import 'package:flags/features/audio/audio.provider.dart';
import 'package:flags/features/audio/sound_data.dart';
import 'package:flags/ui/notifications/tap_button_notification.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ScaledGestureDetector extends StatefulWidget {
  const ScaledGestureDetector({
    super.key,
    this.onTap,
    required this.child,
    this.duration,
    this.onLongPress,
    this.longPressDuration = const Duration(milliseconds: 500),
  });

  final GestureTapCallback? onTap;
  final GestureTapCallback? onLongPress;

  final Duration? duration;

  final Duration longPressDuration;

  final Widget child;

  @override
  State<ScaledGestureDetector> createState() => _ScaledGestureDetectorState();
}

class _ScaledGestureDetectorState extends State<ScaledGestureDetector>
    with SingleTickerProviderStateMixin {
  late final audioService = AudioProvider.of(context);

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

  Future<void> onPointerDown() async {
    if (!isDisabled) {
      _animationController.forward(from: _animationController.value);
    }
  }

  Future<void> onPointerUp() async {
    if (!isDisabled) {
      await audioService.playSfx(GameSfx.button);
      widget.onTap?.call();
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
    return RawGestureDetector(
      gestures: {
        TapGestureRecognizer:
            GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
          TapGestureRecognizer.new,
          (i) {
            if (!mounted) {
              return;
            }

            i.onTapDown = (e) => onPointerDown();
            i.onTapUp = (e) => onPointerUp();
            i.onTapCancel = onPointerCancel;
          },
        ),
        if (widget.onLongPress != null)
          LongPressGestureRecognizer:
              GestureRecognizerFactoryWithHandlers<LongPressGestureRecognizer>(
            () => LongPressGestureRecognizer(
              duration: widget.longPressDuration,
            ),
            (i) {
              i.onLongPress = widget.onLongPress;
            },
          ),
      },
      child: Builder(
        builder: (context) {
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
        },
      ),
    );
  }

  void onTap() {
    if (!isDisabled) {
      widget.onTap?.call();
    }
  }
}
