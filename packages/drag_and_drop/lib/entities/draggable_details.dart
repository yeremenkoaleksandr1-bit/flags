import 'package:flutter/gestures.dart';

class SDraggableDetails {
  SDraggableDetails({
    this.wasAccepted = false,
    required this.velocity,
    required this.offset,
  });

  final bool wasAccepted;

  final Velocity velocity;

  final Offset offset;
}
