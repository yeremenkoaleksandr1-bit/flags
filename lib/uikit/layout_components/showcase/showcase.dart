import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class FShowcaseWidget extends ShowCaseWidget {
  const FShowcaseWidget({
    required this.showcaseKey,
    required super.builder,
    super.autoPlay,
    super.autoPlayDelay,
    super.blurValue,
    super.disableBarrierInteraction,
    super.disableMovingAnimation,
    super.disableScaleAnimation,
    super.enableAutoPlayLock,
    super.enableAutoScroll,
    super.enableShowcase,
    super.onComplete,
    super.onFinish,
    super.onStart,
    super.scrollDuration,
  }) : super(key: showcaseKey);

  final GlobalKey showcaseKey;

  @override
  FShowcaseWidgetState createState() {
    return FShowcaseWidgetState();
  }
}

class FShowcaseWidgetState extends ShowCaseWidgetState<FShowcaseWidget> {
  @override
  Widget build(BuildContext context) {
    if (!enableShowcase) {
      return widget.builder(context);
    }

    return super.build(context);
  }
}
