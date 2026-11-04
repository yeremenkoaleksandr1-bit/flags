
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/uikit/assets/components/hand.dart';
import 'package:flags/uikit/layout_components/showcase/showcase_item.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PuzzleEmblemObjectStep2Showcase extends StatefulWidget {
  const PuzzleEmblemObjectStep2Showcase({
    super.key,
    required this.showcaseKey,
    required this.child,
    required this.onTap,
  });

  final GlobalKey showcaseKey;

  final VoidCallback onTap;

  final Widget child;

  @override
  State<PuzzleEmblemObjectStep2Showcase> createState() =>
      _PuzzleEmblemObjectStep2ShowcaseState();
}

class _PuzzleEmblemObjectStep2ShowcaseState
    extends State<PuzzleEmblemObjectStep2Showcase> {
  bool onReady = false;

  @override
  Widget build(BuildContext context) {
      final mqs = MediaQuery.of(context).size;

      if (!onReady) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) async  {
          await Future.delayed(const Duration(milliseconds: 100));

        });
        onReady = true;
      }


      return FShowcase(
      showcaseKey: widget.showcaseKey,
      onTargetClick: widget.onTap,
      onBarrierClick: widget.onTap,
      tooltip: (bounds) {
        return Positioned(
          top: 0,
          left: 0,
          bottom: 0,
          right: 0,
          child: IgnorePointer(
            child: Stack(
              clipBehavior: Clip.none,
              fit: StackFit.passthrough,
              children: [
                Positioned(
                  bottom: bounds.top - 20,
                  left: bounds.left + bounds.width / 2 - 42,
                  height: 84,
                  width: 64,
                  child: Center(
                    child: Transform.rotate(
                      angle: radians(210),
                      child: UIHand(),
                    )
                        .animate(
                          onPlay: (controller) =>
                              controller.repeat(reverse: true),
                        )
                        .moveX(
                          duration: const Duration(milliseconds: 3000),
                          begin: -64,
                          end: 32,
                        ),
                  ),
                ),
                Positioned(
                  bottom: 64,
                  left: 32,
                  height: 84,
                  width: 64,
                  child: Center(
                    child: Transform.rotate(
                      angle: radians(42),
                      child: UIHand(),
                    )
                        .animate(
                          onPlay: (controller) =>
                              controller.repeat(reverse: true),
                        )
                        .move(
                          duration: const Duration(milliseconds: 2000),
                          begin: const Offset(0, 0),
                          end: const Offset(10, -10),
                        ),
                  ),
                ),
                Positioned(
                  bottom: 64,
                  left: bounds.left + bounds.width / 2 - 128 + 48,
                  height: 84,
                  width: mqs.width / 2,
                  child: Center(
                    child: FText(
                      "And rotate this object",
                      textAlign: TextAlign.center,
                      textStyle: const TextStyle(height: 1),
                    ),
                  ),
                ),
                Positioned(
                  bottom: bounds.top + 42,
                  left: bounds.left + bounds.width / 2,
                  width: mqs.width / 2,
                  height: 84,
                  child: Center(
                    child: FText(
                      "Choose correct scale",
                      textAlign: TextAlign.center,
                      textStyle: const TextStyle(height: 1),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      targetPadding: const Pad(all: 2),
      blurValue: 0,
      overlayOpacity: 0.5,
      disableDefaultTargetGestures: false,
      disableBarrierInteraction: false,
      child: widget.child,
    );
  }
}
