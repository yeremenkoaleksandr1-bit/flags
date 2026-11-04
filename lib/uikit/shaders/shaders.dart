import 'dart:ui';

base class GameShaders {
  static late final FragmentProgram antialias;
  static late final FragmentProgram outline;
  static late final FragmentProgram pixelFade;
  static late final FragmentProgram strokeText;
  static late final FragmentProgram widgetOutline;

  static late final FragmentProgram spriteImage;

  static Future<void> init() async {
    antialias = await FragmentProgram.fromAsset("shaders/antialias.frag");

    spriteImage = await FragmentProgram.fromAsset("shaders/sprite.frag");

    pixelFade = await FragmentProgram.fromAsset("shaders/pixel_fade.frag");

    outline = await FragmentProgram.fromAsset("shaders/outline.frag");

    strokeText = await FragmentProgram.fromAsset("shaders/stroke_text.frag");

    widgetOutline = await FragmentProgram.fromAsset(
      "shaders/widget_outline.frag",
    );
  }
}
