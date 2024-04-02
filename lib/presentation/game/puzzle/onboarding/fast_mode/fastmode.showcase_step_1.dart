import 'package:armar/armar.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/uikit/assets/components/hand.dart';
import 'package:flags/uikit/layout_components/showcase/showcase_item.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PuzzleFastModeStep1Showcase extends StatefulWidget {
  const PuzzleFastModeStep1Showcase({
    super.key,
    required this.showcaseKey,
    required this.child,
    required this.onTap,
  });

  final GlobalKey showcaseKey;

  final Widget child;

  final VoidCallback onTap;

  @override
  State<PuzzleFastModeStep1Showcase> createState() =>
      _PuzzleFastModeStep1ShowcaseState();
}

class _PuzzleFastModeStep1ShowcaseState
    extends State<PuzzleFastModeStep1Showcase> {
  @override
  Widget build(BuildContext context) {
    final mqs = context.mediaQuerySize;

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
                  top: bounds.top + bounds.height,
                  left: bounds.left + 48,
                  height: 84,
                  width: 64,
                  child: Center(
                    child: Transform.rotate(
                      angle: radians(-24),
                      child: Transform.scale(
                        scaleX: -1,
                        child: UIHand(),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: bounds.top + 152,
                  left: 0,
                  right: 0,
                  height: 84,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FText(
                        "You need to collect this flag in a certain amount of time",
                        textAlign: TextAlign.center,
                        textStyle: const TextStyle(height: 1),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      targetPadding: const Pad(all: 10),
      blurValue: 8,
      overlayOpacity: 0.5,
      disableDefaultTargetGestures: false,
      disableBarrierInteraction: false,
      child: widget.child,
    );
  }
}
