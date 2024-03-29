import 'dart:ui';

import 'package:flags/uikit/shaders/shaders.dart';
import 'package:flutter/material.dart';

class PixelFade extends StatefulWidget {
  final Widget? child;

  final AnimationController controller;

  const PixelFade({
    super.key,
    required this.child,
    required this.controller,
  });

  @override
  State<PixelFade> createState() => _PixelFadeState();
}

class _PixelFadeState extends State<PixelFade> with TickerProviderStateMixin {
  AnimationController get controller => widget.controller;
  late final Animation<double> animation;
  late FragmentShader shader = GameShaders.pixelFade.fragmentShader();

  @override
  void initState() {
    animation = Tween<double>(
      begin: 0,
      end: 2,
    ).animate(controller);

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return ShaderMask(
              shaderCallback: (bounds) {
                final shader = this.shader;
                shader.setFloat(0, animation.value);
                shader.setFloat(1, bounds.width);
                shader.setFloat(2, bounds.height);
                shader.setFloat(3, constraints.maxWidth);
                shader.setFloat(4, constraints.maxHeight);
                return shader;
              },
              child: widget.child,
            );
          },
        );
      },
    );
  }
}
