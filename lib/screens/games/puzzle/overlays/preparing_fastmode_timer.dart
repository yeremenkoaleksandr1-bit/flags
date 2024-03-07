import 'dart:ui';

import 'package:armar/logger.dart';
import 'package:armar/rx/rx.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/material.dart';

import '../components/timer/animated_seconds_timer.dart';

class PreparingFastModeTimer extends StatefulWidget {
  const PreparingFastModeTimer({super.key, required this.preparingTimer});

  final Stream<int> preparingTimer;

  OverlayEntry overlay() {
    return OverlayEntry(builder: (BuildContext context) {
      return PreparingFastModeTimer(
        preparingTimer: preparingTimer,
      );
    });
  }

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
              filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
              child: ColoredBox(
                color: ThemePalette.black.withOpacity(0.8),
              ),
            ),
          ),
          Center(
            child: AnimatedSecondsTimer(
              timerStream: widget.preparingTimer,
            ),
          )
        ],
      ),
    );
  }
}
