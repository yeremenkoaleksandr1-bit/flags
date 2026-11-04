import 'dart:ui';

import 'package:flutter/foundation.dart';

/// Custom fragment shaders.
///
/// On Android < 10 Flutter renders with Skia, which compiles runtime shaders
/// in strict GLSL ES 2.0 mode. A shader that fails to compile there makes
/// [FragmentProgram.fromAsset] throw. Every shader is therefore loaded
/// independently and is `null` when unavailable, so callers can fall back to
/// plain painting instead of the whole app failing to start.
base class GameShaders {
  static FragmentProgram? antialias;
  static FragmentProgram? outline;
  static FragmentProgram? pixelFade;
  static FragmentProgram? strokeText;
  static FragmentProgram? widgetOutline;

  static FragmentProgram? spriteImage;

  static Future<void> init() async {
    final results = await Future.wait([
      _load("shaders/antialias.frag"),
      _load("shaders/sprite.frag"),
      _load("shaders/pixel_fade.frag"),
      _load("shaders/outline.frag"),
      _load("shaders/stroke_text.frag"),
      _load("shaders/widget_outline.frag"),
    ]);

    antialias = results[0];
    spriteImage = results[1];
    pixelFade = results[2];
    outline = results[3];
    strokeText = results[4];
    widgetOutline = results[5];
  }

  static Future<FragmentProgram?> _load(String asset) async {
    try {
      return await FragmentProgram.fromAsset(asset);
    } catch (error, stackTrace) {
      debugPrint('GameShaders: failed to load $asset: $error\n$stackTrace');
      return null;
    }
  }
}
