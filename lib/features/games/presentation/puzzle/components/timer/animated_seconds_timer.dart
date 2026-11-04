import 'package:flags/features/games/presentation/puzzle/components/winner_streak_fast_mode.dart';
import 'package:flags/uikit/components/safe_area/safe_area.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AnimatedSecondsTimer extends StatefulWidget {
  const AnimatedSecondsTimer({
    super.key,
    required this.timerStream,
  });

  final ValueListenable<int> timerStream;

  @override
  State<AnimatedSecondsTimer> createState() => _AnimatedSecondsTimerState();
}

class _AnimatedSecondsTimerState extends State<AnimatedSecondsTimer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          height: 200,
          left: 24,
          right: 24,
          child: ValueListenableBuilder(
            valueListenable: widget.timerStream,
            builder: (
              BuildContext context,
              int value,
              Widget? child,
            ) {
              if (value == -1) {
                return const SizedBox.shrink();
              }

              return const GameSafeArea(
                child: Center(
                  child: WinnerStreakFastModeView(),
                ),
              );
            },
          ),
        ),
        Center(
          child: ValueListenableBuilder(
            valueListenable: widget.timerStream,
            builder: (
              BuildContext context,
              int value,
              Widget? child,
            ) {
              if (value == -1) {
                return const SizedBox.shrink();
              }
              return FText(
                "$value",
                textStyle: const TextStyle(
                  fontSize: 128,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
