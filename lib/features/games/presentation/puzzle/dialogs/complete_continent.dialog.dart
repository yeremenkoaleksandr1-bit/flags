
import 'package:flags/domain/domain.dart';
import 'package:flags/ui/dialogs/dialogs.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PuzzleCompleteContinentDialog extends DialogWidget {
  const PuzzleCompleteContinentDialog({
    super.key,
    required this.continent,
    required this.onExit,
  });

  final ContinentType continent;
  final void Function(BuildContext context) onExit;

  @override
  Widget buildContainer(BuildContext context, Widget child) {
    return build(context);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        buildContent(),
        GestureDetector(
          onTap: () => onExit(context),
        ),
      ],
    );
  }

  Stack buildContent() {
    return Stack(
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxHeight: 300,
            ),
            child: Stack(
              children: [
                Center(
                  child: Image.asset(
                    createContinentImagePath(continent),
                  )
                      .animate(
                        onPlay: (controller) =>
                            controller.repeat(reverse: true),
                      )
                      .rotate(
                        end: 0.005,
                        begin: -0.005,
                        curve: Curves.linear,
                        duration: const Duration(
                          milliseconds: 2000,
                        ),
                      ),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FText(
                        createContinentTitle(continent),
                        textStyle: const TextStyle(fontSize: 64, height: 1),
                        textAlign: TextAlign.center,
                      ),
                      FText(
                        "completed",
                        textAlign: TextAlign.center,
                        textStyle: const TextStyle(fontSize: 32, height: 1),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const Positioned(
          bottom: 0,
          right: 0,
          left: 0,
          child: Center(
            child: Text(
              "tap on the screen \nto return to level selection",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ThemePalette.white,
                fontSize: 24,
                height: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
