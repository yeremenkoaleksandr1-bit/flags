import 'dart:math' as math;

import 'package:flutter/widgets.dart';

class PhoneAdaptiveData extends InheritedWidget {
  const PhoneAdaptiveData({
    super.key,
    required this.scale,
    required super.child,
  });

  final double scale;

  static double scaleOf(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<PhoneAdaptiveData>()
            ?.scale ??
        1.0;
  }

  @override
  bool updateShouldNotify(PhoneAdaptiveData oldWidget) {
    return oldWidget.scale != scale;
  }
}

class PhoneAdaptiveFrame extends StatelessWidget {
  const PhoneAdaptiveFrame({super.key, required this.child});

  static const double _referenceWidth = 390;
  static const double _referenceHeight = 780;
  static const double _minScale = 0.84;
  static const double _maxScale = 1.08;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);

        final scale = math
            .min(size.width / _referenceWidth, size.height / _referenceHeight)
            .clamp(_minScale, _maxScale);

        final viewportSize = Size(size.width / scale, size.height / scale);

        final adaptiveChild = MediaQuery(
          data: mediaQuery.copyWith(
            size: viewportSize,
            padding: _scaledInsets(mediaQuery.padding, scale),
            viewPadding: _scaledInsets(mediaQuery.viewPadding, scale),
            viewInsets: _scaledInsets(mediaQuery.viewInsets, scale),
            systemGestureInsets: _scaledInsets(
              mediaQuery.systemGestureInsets,
              scale,
            ),
            textScaler: TextScaler.linear(
              mediaQuery.textScaler.scale(1) * scale,
            ),
          ),
          child: PhoneAdaptiveData(scale: scale, child: child),
        );

        return FittedBox(
          fit: BoxFit.contain,
          alignment: Alignment.center,
          child: SizedBox.fromSize(size: viewportSize, child: adaptiveChild),
        );
      },
    );
  }

  EdgeInsets _scaledInsets(EdgeInsets value, double scale) {
    return EdgeInsets.fromLTRB(
      value.left / scale,
      value.top / scale,
      value.right / scale,
      value.bottom / scale,
    );
  }
}
