import 'package:flame/extensions.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

typedef FlameRenderFunction = void Function(
  Canvas canvas, {
  Vector2? position,
  Vector2? size,
  Anchor anchor,
  Paint? overridePaint,
});

class FlameRenderWidget extends SingleChildRenderObjectWidget {
  final Vector2 size;
  final Vector2 position;

  final Anchor anchor;

  const FlameRenderWidget({
    super.key,
    required this.render,
    this.isComplex = false,
    this.willChange = false,
    required this.position,
    required this.size,
    this.anchor = Anchor.topLeft,
    super.child,
  }) : assert((!isComplex && !willChange));

  final FlameRenderFunction render;

  final bool isComplex;

  final bool willChange;

  @override
  RenderCustomPaint createRenderObject(BuildContext context) {
    return RenderCustomPaint(
      painter: FlamePainter(
        render: render,
        position: position,
        anchor: anchor,
        size: size,
        overridePaint: Paint()..isAntiAlias = true,
      ),
      preferredSize: size.toSize(),
      isComplex: isComplex,
      willChange: willChange,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderCustomPaint renderObject,
  ) {
    renderObject
      ..preferredSize = size.toSize()
      ..isComplex = isComplex
      ..willChange = willChange;
  }

  @override
  void didUnmountRenderObject(RenderCustomPaint renderObject) {
    renderObject
      ..preferredSize = Size.zero
      ..painter = null
      ..foregroundPainter = null;
  }
}

class FlamePainter extends CustomPainter {
  FlamePainter({
    required this.render,
    this.position,
    this.size,
    required this.anchor,
    this.overridePaint,
  });

  final FlameRenderFunction render;
  final Vector2? position;
  final Vector2? size;
  final Anchor anchor;
  final Paint? overridePaint;

  @override
  void paint(Canvas canvas, Size size) => render(
        canvas,
        position: position,
        size: this.size ?? size.toVector2(),
        anchor: anchor,
        overridePaint: overridePaint,
      );

  @override
  bool shouldRepaint(covariant FlamePainter oldDelegate) =>
      oldDelegate.render != render ||
      oldDelegate.position != position ||
      oldDelegate.anchor != anchor ||
      oldDelegate.overridePaint != overridePaint;
}
