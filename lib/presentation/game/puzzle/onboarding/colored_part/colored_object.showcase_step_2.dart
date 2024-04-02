import 'package:armar/armar.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:drag_and_drop/extensions/render_box.dart';
import 'package:flags/uikit/assets/components/hand.dart';
import 'package:flags/uikit/layout_components/showcase/showcase_item.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flags/uikit/utils/render_box_exposed.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PuzzleColoredObjectStep2Showcase extends StatefulWidget {
  const PuzzleColoredObjectStep2Showcase({
    super.key,
    required this.showcaseKey,
    required this.colorsListExposer,
    required this.child,
    required this.onTap,
  });

  final GlobalKey showcaseKey;

  final RenderBoxExposer colorsListExposer;

  final VoidCallback onTap;

  final Widget child;

  @override
  State<PuzzleColoredObjectStep2Showcase> createState() =>
      _PuzzleColoredObjectStep2ShowcaseState();
}

class _PuzzleColoredObjectStep2ShowcaseState
    extends State<PuzzleColoredObjectStep2Showcase> {
  @override
  Widget build(BuildContext context) {
    final mqs = context.mediaQuerySize;

    return FShowcase(
      showcaseKey: widget.showcaseKey,
      onTargetClick: widget.onTap,
      onBarrierClick: widget.onTap,
      tooltip: (bounds) {
        final colorsListRect = widget.colorsListExposer.renderBox.value!.rect;

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
                  top: colorsListRect.top - 64,
                  left: colorsListRect.left,
                  height: 84,
                  width: 64,
                  child: Center(
                    child: Transform.rotate(
                      angle: radians(-210),
                      child: UIHand(),
                    )
                        .animate(
                          onPlay: (controller) =>
                              controller.repeat(reverse: true),
                        )
                        .moveX(
                          duration: const Duration(milliseconds: 3000),
                          begin: -64 + 16,
                          end: colorsListRect.width - 64 - 16,
                        ),
                  ),
                ),
                Positioned(
                  top: bounds.top + 128,
                  left: bounds.width / 2,
                  height: 84,
                  width: 64,
                  child: Center(
                    child: Transform.rotate(
                      angle: radians(210),
                      child: Transform.scale(
                        scaleX: -1,
                        child: UIHand(),
                      ),
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
                  top: colorsListRect.top - 72 * 2,
                  left: 0,
                  height: 84,
                  width: mqs.width,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FText(
                        "You can choose the color of the object",
                        textAlign: TextAlign.center,
                        textStyle: const TextStyle(height: 1),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: bounds.top + 42,
                  left: 0,
                  width: mqs.width,
                  height: 84,
                  child: Center(
                    child: FText(
                      "and after drag this object to flag",
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
