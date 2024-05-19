import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:drag_and_drop/extensions/render_box.dart';
import 'package:flags/core/extensions/offset.dart';
import 'package:flags/core/flutter_engine.dart';
import 'package:flags/uikit/assets/components/hand.dart';
import 'package:flags/uikit/layout_components/showcase/showcase_item.dart';
import 'package:flags/uikit/utils/render_box_exposed.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class PuzzleCommonObjectShowcase extends StatefulWidget {
  const PuzzleCommonObjectShowcase({
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
  State<PuzzleCommonObjectShowcase> createState() =>
      _PuzzleCommonObjectShowcaseState();
}

class _PuzzleCommonObjectShowcaseState extends State<PuzzleCommonObjectShowcase>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;

  bool onReady = false;
  BezierCurve? lineCurve = null;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 1800,
      ),
    );

    FlutterEngine.widgetPostFrameCallback((timeStamp) {
      controller.repeat();
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!onReady) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        widget.onReady();
      });
      onReady = true;
    }

    return FShowcase(
      showcaseKey: widget.showcaseKey,
      tooltip: (bounds) {
        lineCurve ??= BezierCurve.fromVector(
          bounds.center,
          widget.flagExposer.renderBox.value!.rect.center,
          -40,
        );

        return AnimatedBuilder(
          animation: controller,
          builder: (BuildContext context, Widget? child) {
            final value = controller.value;

            final position = lineCurve?.lerp(value) ?? bounds.center;

            return Positioned(
              top: position.dy,
              left: position.dx,
              child: child!,
            );
          },
          child: SizedBox(
            height: 84,
            child: Transform.rotate(
              angle: radians(-25),
              child: UIHand(),
            ),
          ),
        );
      },
      targetPadding: const Pad(all: 10),
      blurValue: 0,
      overlayOpacity: 0.5,
      disableDefaultTargetGestures: true,
      disableBarrierInteraction: true,
      onTargetClick: () {},
      child: widget.child,
    );
  }
}
