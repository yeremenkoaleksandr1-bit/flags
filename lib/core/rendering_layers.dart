import 'package:flutter/rendering.dart';

class RenderingLayers {
  static final RenderingLayers _singleton = RenderingLayers._internal();

  factory RenderingLayers() {
    return _singleton;
  }

  RenderingLayers._internal();

  Layer ui = ContainerLayer();
  Layer overlay = ContainerLayer();
}
