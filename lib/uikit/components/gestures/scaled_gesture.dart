import 'package:flags/features/app/features/audio/domain/sound_data.dart';
import 'package:flags/features/app/features/audio/presentation/bloc/audio_cubit.dart';
import 'package:flags/features/app/features/vibration/presentation/bloc/vibration_cubit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  IAudioCubit get audioCubit => context.read<IAudioCubit>();

  IVibrationCubit get vibrationCubit => context.read<IVibrationCubit>();

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
      vibrationCubit.vibrate(milliseconds: 50);
      await audioCubit.playSfx(GameSfx.button);

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
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget? child) {
          final value = _animationController.value;

          return Transform.scale(
            scale: 1 - (0.05 * Curves.easeInBack.transform(value)),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }

  void onTap() {
    if (!isDisabled) {
      widget.onTap?.call();
    }
  }
}
