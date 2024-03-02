import 'package:flags/core/extensions/image.dart';
import 'package:flags/uikit/assets/assets.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class Background extends LeafRenderObjectWidget {
  const Background({super.key});

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderFittedBox(
      child: BackgroundRenderBox(),
      fit: BoxFit.cover,
      alignment: Alignment.bottomCenter,
    );
  }
}

class BackgroundRenderBox extends RenderBox {
  late final UIImage _image = Assets.images.background.image;

  @override
  bool get sizedByParent => true;

  @override
  void performResize() {
    size = _image.size.toSize();
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.canvas.drawImage(
      _image,
      Offset.zero,
      Paint(),
    );
  }
}
