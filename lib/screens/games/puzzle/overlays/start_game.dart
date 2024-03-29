import 'dart:ui';

import 'package:flags/core/flutter_engine.dart';
import 'package:flags/screens/games/puzzle/components/timer/animated_seconds_timer.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/material.dart';

class PreparingFastModeInitializationGame extends StatefulWidget {
  const PreparingFastModeInitializationGame({
    super.key,
    required this.preparingTimer,
    this.onReady,
  });

  final Stream<int> preparingTimer;

  final VoidCallback? onReady;

  Future<dynamic> showDialog(BuildContext context) async {
    return await showGeneralDialog(
      context: context,
      pageBuilder: (
        BuildContext context,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return PreparingFastModeInitializationGame(
          preparingTimer: preparingTimer,
          onReady: onReady,
        );
      },
    );
  }

  @override
  State<PreparingFastModeInitializationGame> createState() =>
      _PreparingFastModeInitializationGameState();
}

class _PreparingFastModeInitializationGameState
    extends State<PreparingFastModeInitializationGame> {
  @override
  void initState() {
    super.initState();

    FlutterEngine.widgetPostFrameCallback((timeStamp) {
      widget.onReady?.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
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
        ),
      ],
    );
  }
}
