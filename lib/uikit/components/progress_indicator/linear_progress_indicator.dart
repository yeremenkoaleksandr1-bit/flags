// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const int _kIndeterminateLinearDuration = 1800;

abstract class ProgressIndicator extends StatefulWidget {
  const ProgressIndicator({
    super.key,
  });
}

class _LinearProgressIndicatorPainter extends CustomPainter {
  const _LinearProgressIndicatorPainter({
    required this.backgroundColor,
    required this.animationValue,
    required this.indicatorBorderRadius,
  });

  final Color backgroundColor;
  final double animationValue;
  final Radius indicatorBorderRadius;

  static const Curve line1Head = Interval(
    0.0,
    750.0 / _kIndeterminateLinearDuration,
    curve: Cubic(0.2, 0.0, 0.8, 1.0),
  );
  static const Curve line1Tail = Interval(
    333.0 / _kIndeterminateLinearDuration,
    (333.0 + 750.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.4, 0.0, 1.0, 1.0),
  );
  static const Curve line2Head = Interval(
    1000.0 / _kIndeterminateLinearDuration,
    (1000.0 + 567.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.0, 0.0, 0.65, 1.0),
  );
  static const Curve line2Tail = Interval(
    1267.0 / _kIndeterminateLinearDuration,
    (1267.0 + 533.0) / _kIndeterminateLinearDuration,
    curve: Cubic(0.10, 0.0, 0.45, 1.0),
  );

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    void drawBar(double x, double width) {
      if (width <= 0.0) {
        return;
      }

      final double left = x;

      final Rect rect = Offset(left, 0.0) & Size(width, size.height);
      final RRect rrect = RRect.fromRectAndRadius(rect, indicatorBorderRadius);
      canvas.drawRRect(rrect, paint);
    }

    final double x1 = size.width * line1Tail.transform(animationValue);
    final double width1 = size.width * line1Head.transform(animationValue) - x1;

    final double x2 = size.width * line2Tail.transform(animationValue);
    final double width2 = size.width * line2Head.transform(animationValue) - x2;

    drawBar(x1, width1);
    drawBar(x2, width2);
  }

  @override
  bool shouldRepaint(_LinearProgressIndicatorPainter oldPainter) {
    return oldPainter.backgroundColor != backgroundColor ||
        oldPainter.animationValue != animationValue ||
        oldPainter.indicatorBorderRadius != indicatorBorderRadius;
  }
}

class FLinearProgressIndicator extends ProgressIndicator {
  const FLinearProgressIndicator({
    super.key,
    this.minHeight,
  }) : assert(minHeight == null || minHeight > 0);

  final double? minHeight;

  @override
  State<FLinearProgressIndicator> createState() =>
      _LinearProgressIndicatorState();
}

class _LinearProgressIndicatorState extends State<FLinearProgressIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: _kIndeterminateLinearDuration),
      vsync: this,
    );
    _controller.repeat();
  }

  @override
  void didUpdateWidget(FLinearProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_controller.isAnimating) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildIndicator(
    BuildContext context,
    double animationValue,
  ) {
    return Container(
      padding: const Pad(all: 4),
      decoration: const ShapeDecoration(
        color: ThemePalette.white,
        shape: StadiumBorder(),
      ),
      constraints: const BoxConstraints(
        minWidth: double.infinity,
        minHeight: 18,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(48),
        child: CustomPaint(
          painter: _LinearProgressIndicatorPainter(
            backgroundColor: ThemePalette.yellow,
            animationValue: animationValue,
            indicatorBorderRadius: const Radius.circular(48),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller.view,
      builder: (BuildContext context, Widget? child) {
        return _buildIndicator(context, _controller.value);
      },
    );
  }
}
