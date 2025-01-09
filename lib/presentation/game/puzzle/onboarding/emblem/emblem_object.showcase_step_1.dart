import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/uikit/assets/components/hand.dart';
import 'package:flags/uikit/layout_components/showcase/showcase_item.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flags/uikit/utils/render_box_exposed.dart';
import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PuzzleEmblemObjectStep1Showcase extends StatefulWidget {
  const PuzzleEmblemObjectStep1Showcase({
    super.key,
    required this.showcaseKey,
    required this.child,
    required this.flagExposer,
    required this.onReady,
  });

  final GlobalKey showcaseKey;

  final RenderBoxExposer flagExposer;

  final Widget child;

  final void Function() onReady;

  @override
  State<PuzzleEmblemObjectStep1Showcase> createState() =>
      _PuzzleEmblemObjectStep1ShowcaseState();
}

class _PuzzleEmblemObjectStep1ShowcaseState
    extends State<PuzzleEmblemObjectStep1Showcase> {
  bool onReady = false;

  @override
  Widget build(BuildContext context) {
    if (!onReady) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async  {
        await Future.delayed(const Duration(milliseconds: 100));
        widget.onReady();
      });
      onReady = true;
    }

    final mqs = MediaQuery.of(context).size;

    return FShowcase(
      showcaseKey: widget.showcaseKey,
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
                  top: bounds.top + bounds.height - 10,
                  left: bounds.left - 10,
                  height: 84,
                  width: 64,
                  child: Center(
                    child: Transform.rotate(
                      angle: radians(12),
                      child: UIHand(),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 64,
                  left: mqs.width / 4,
                  width: mqs.width / 2,
                  height: 84,
                  child: Center(
                    child: FText(
                      "This is emblem part",
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
      targetPadding: const Pad(all: 10),
      blurValue: 0,
      overlayOpacity: 0.5,
      disableDefaultTargetGestures: false,
      disableBarrierInteraction: false,
      onTargetClick: () {},
      child: widget.child,
    );
  }
}
