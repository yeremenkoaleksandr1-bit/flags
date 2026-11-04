import 'package:flags/core/extensions/image.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SpriteUIWidget extends LeafRenderObjectWidget {
  final UIImage image;

  final Color color;
  final BlendMode blendMode;
  final FilterQuality filterQuality;

  const SpriteUIWidget({
    super.key,
    required this.image,
    this.color = Colors.white,
    this.blendMode = BlendMode.modulate,
    this.filterQuality = FilterQuality.high,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return SpriteUIRenderBox(
      image,
      color,
      blendMode,
      filterQuality,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant SpriteUIRenderBox renderObject,
  ) {
    renderObject.updateValues(
      image,
      color,
      blendMode,
      filterQuality,
    );
  }
}

class SpriteUIRenderBox extends RenderShiftedBox with RenderProxyBoxMixin {
  UIImage image;

  Color color;
  BlendMode blendMode;
  FilterQuality filterQuality;

  late Paint spritePaint = Paint()
    ..filterQuality = filterQuality
    ..colorFilter = ColorFilter.mode(
      color,
      blendMode,
    );

  SpriteUIRenderBox(
    this.image,
    this.color,
    this.blendMode,
    this.filterQuality,
  ) : super(null);

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    return size.contains(position);
  }

  void updateValues(
    UIImage newImage,
    Color newColor,
    BlendMode newBlendMode,
    FilterQuality newFilterQuality,
  ) {
    if (newColor != color ||
        newBlendMode != blendMode ||
        filterQuality != newFilterQuality) {
      color = newColor;
      blendMode = newBlendMode;
      filterQuality = newFilterQuality;

      spritePaint = Paint()
        ..filterQuality = filterQuality
        ..colorFilter = ColorFilter.mode(
          color,
          blendMode,
        );
    }

    image = newImage;
    markNeedsPaint();
  }

  @override
  void performLayout() {
    // Calculate the aspect ratio of the image
    final aspect = image.size.x / image.size.y;

    // Use parent constraints to calculate the size
    double boxWidth = constraints.maxWidth;
    double boxHeight = constraints.maxWidth / aspect;

    // If the calculated height exceeds the maxHeight, recalculate based on height
    if (boxHeight > constraints.maxHeight) {
      boxHeight = constraints.maxHeight;
      boxWidth = boxHeight * aspect;
    }

    size = constraints.constrain(Size(boxWidth, boxHeight));
  }

  void draw(PaintingContext context, Offset offset, Canvas canvas) {
    canvas.drawImageRect(
      image,
      Offset.zero & image.size.toSize(),
      offset & size,
      spritePaint,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    draw(context, offset, context.canvas);
  }
}
