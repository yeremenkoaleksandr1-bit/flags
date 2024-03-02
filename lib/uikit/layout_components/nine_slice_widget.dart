import 'package:flags/core/extensions/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'sprite_widget.dart';

class NineSliceWidget extends SingleChildRenderObjectWidget {
  final double left, right, top, bottom;
  final UIImage image;

  final Color color;
  final BlendMode blendMode;
  final FilterQuality filterQuality;

  const NineSliceWidget({
    Key? key,
    required this.image,
    this.left = 10,
    this.right = 10,
    this.top = 10,
    this.bottom = 10,
    this.color = Colors.white,
    this.blendMode = BlendMode.modulate,
    this.filterQuality = FilterQuality.high,
    super.child,
  }) : super(
          key: key,
        );

  @override
  RenderObject createRenderObject(BuildContext context) {
    return NineSliceRenderBox(
      image,
      color,
      blendMode,
      filterQuality,
      left,
      right,
      top,
      bottom,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant NineSliceRenderBox renderObject,
  ) {
    renderObject.updateValues(
      image,
      color,
      blendMode,
      filterQuality,
      left,
      right,
      top,
      bottom,
    );
  }
}

class NineSliceRenderBox extends SpriteUIRenderBox {
  double left, right, top, bottom;

  NineSliceRenderBox(
    super.image,
    super.color,
    super.blendMode,
    super.filterQuality,
    this.left,
    this.right,
    this.top,
    this.bottom,
  );

  @override
  void performLayout() {
    final childConstraints = constraints;
    size = (child!..layout(childConstraints, parentUsesSize: true)).size;
  }

  @override
  void draw(PaintingContext context, Offset offset, Canvas canvas) {
    canvas.drawImageNine(
      image,
      Rect.fromLTRB(left, top, image.width - right, image.height - bottom),
      offset & size,
      spritePaint,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    super.paint(context, offset);

    if (child != null) {
      context.paintChild(child!, offset);
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (hitTestChildren(result, position: position)) {
      return true;
    }
    return super.hitTest(result, position: position);
  }

  @override
  void updateValues(
    UIImage newImage,
    Color newColor,
    BlendMode newBlendMode,
    FilterQuality newFilterQuality, [
    double? newLeft,
    double? newRight,
    double? newTop,
    double? newBottom,
  ]) {
    left = newLeft ?? left;
    right = newRight ?? right;
    top = newTop ?? top;
    bottom = newBottom ?? bottom;

    super.updateValues(
      newImage,
      newColor,
      newBlendMode,
      newFilterQuality,
    );
  }
}
