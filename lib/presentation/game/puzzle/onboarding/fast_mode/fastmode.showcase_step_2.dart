import 'dart:ui';

import 'package:state_manager/state_manager.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/uikit/assets/components/money.dart';
import 'package:flags/uikit/layout_components/layout_components.dart';
import 'package:flags/uikit/layout_components/showcase/showcase_item.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flutter/material.dart';

class PuzzleFastModeStep2Showcase extends StatefulWidget {
  const PuzzleFastModeStep2Showcase({
    super.key,
    required this.showcaseKey,
    required this.child,
    required this.onTap,
  });

  final GlobalKey showcaseKey;

  final Widget child;

  final VoidCallback onTap;

  @override
  State<PuzzleFastModeStep2Showcase> createState() =>
      _PuzzleFastModeStep2ShowcaseState();
}

class _PuzzleFastModeStep2ShowcaseState
    extends State<PuzzleFastModeStep2Showcase> {
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
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaY: 8, sigmaX: 8),
                    child: const ColoredBox(
                      color: Colors.black45,
                    ),
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          FText(
                            "The faster you collect the flag,\nthe more money you will receive",
                            textAlign: TextAlign.center,
                            textStyle: const TextStyle(
                              height: 1,
                            ),
                          ),
                          Gap.v24,
                          SizedBox(
                            height: 84,
                            child: Center(
                              child: UIMoney(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 24,
                  child: Center(
                    child: FText(
                      "Tap to start",
                      textAlign: TextAlign.center,
                      textStyle: const TextStyle(
                        height: 1,
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
