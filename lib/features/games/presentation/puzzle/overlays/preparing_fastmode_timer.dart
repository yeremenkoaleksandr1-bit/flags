import 'dart:ui';

import 'package:flags/features/games/presentation/puzzle/components/timer/animated_seconds_timer.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PreparingFastModeTimer extends StatefulWidget {
  const PreparingFastModeTimer({super.key, required this.preparingTimer});

  final ValueListenable<int> preparingTimer;

  // OverlayEntry overlay() {
  //   return OverlayEntry(
  //     builder: (BuildContext context) {
  //       return PreparingFastModeTimer(
  //         preparingTimer: preparingTimer,
  //       );
  //     },
  //   );
  // }

  @override
  State<PreparingFastModeTimer> createState() => _PreparingFastModeTimerState();
}

class _PreparingFastModeTimerState extends State<PreparingFastModeTimer> {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: ColoredBox(
                color: ThemePalette.black.withOpacity(0.9),
              ),
            ),
          ),
          AnimatedSecondsTimer(
            timerStream: widget.preparingTimer,
          ),
        ],
      ),
    );
  }
}
