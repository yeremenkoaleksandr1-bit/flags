// ignore_for_file: must_be_immutable

import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ShakeWidget extends Animate {
  ShakeWidget({
    super.key,
    required super.child,
    required super.controller,
  }) : super(
          autoPlay: false,
          effects: [
            ShakeEffect(
              duration: controller?.duration,
              offset: const Offset(0, 0),
              rotation: 0.09,
            ),
          ],
        );
}
