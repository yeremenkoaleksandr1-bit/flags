import 'dart:ui';

base class GameShaders {
  static late final FragmentProgram antialias;
  static late final FragmentProgram outline;
  static late final FragmentProgram pixelFade;

  static late final FragmentProgram spriteImage;

  static Future<void> init() async {
    antialias = await FragmentProgram.fromAsset("shaders/antialias.frag");

    spriteImage = await FragmentProgram.fromAsset("shaders/sprite.frag");

    pixelFade = await FragmentProgram.fromAsset("shaders/pixel_fade.frag");

    outline = await FragmentProgram.fromAsset("shaders/outline.frag");
  }
}
