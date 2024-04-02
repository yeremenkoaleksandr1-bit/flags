import 'package:armar/armar.dart';
import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class FShowcase extends StatelessWidget {
  const FShowcase({
    super.key,
    required this.child,
    required this.showcaseKey,
    required this.tooltip,
    this.tooltipPosition = TooltipPosition.top,
    this.targetShapeBorder = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
    ),
    this.targetPadding = EdgeInsets.zero,
    this.disableDefaultTargetGestures = false,
    this.disableBarrierInteraction = false,
    this.onTargetLongPress,
    this.onTargetDoubleTap,
    this.onBarrierClick,
    this.onTargetClick,
    this.blurValue = 4,
    this.overlayOpacity = 0.75,
  });

  final TooltipPosition tooltipPosition;
  final GlobalKey showcaseKey;

  final ShapeBorder targetShapeBorder;

  final Widget Function(Rect rectBound) tooltip;

  final Widget child;

  final EdgeInsets targetPadding;

  final bool disableDefaultTargetGestures;
  final bool disableBarrierInteraction;

  final VoidCallback? onTargetLongPress;
  final VoidCallback? onTargetDoubleTap;
  final VoidCallback? onBarrierClick;
  final VoidCallback? onTargetClick;

  final double blurValue;
  final double overlayOpacity;

  @override
  Widget build(BuildContext context) {
    final mqs = context.mediaQuerySize;

    return Showcase.withWidget(
      key: showcaseKey,
      height: 0,
      width: mqs.width,
      tooltipPosition: tooltipPosition,
      targetShapeBorder: targetShapeBorder,
      targetPadding: targetPadding,
      disableDefaultTargetGestures: disableDefaultTargetGestures,
      onTargetLongPress: onTargetLongPress,
      onTargetDoubleTap: onTargetDoubleTap,
      onBarrierClick: onBarrierClick,
      onTargetClick: onTargetClick,
      blurValue: blurValue,
      overlayOpacity: overlayOpacity,
      disableBarrierInteraction: disableBarrierInteraction,
      container: tooltip,
      child: child,
    );
  }
}
