import 'package:flags/core/extensions/image.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/widgets.dart';

import '../base/flippable.dart';

class ImageGameObject extends FlippableGameObject {
  final UIImage image;

  ImageGameObject({
    super.key,
    required this.image,
    required super.name,
    super.position,
    super.scale,
    super.size,
    super.rotation,
    super.flippedHorizontal,
    super.flippedVertical,
  });

  @override
  Future<ImageGameObject> init() async {
    return copyWith(
      size: image.size / 64,
    );
  }

  @override
  ImageGameObject copyWith({
    Key? key,
    String? name,
    String? uniqueName,
    Vector2? position,
    double? scale,
    Vector2? size,
    double? rotation,
    bool? flippedHorizontal,
    bool? flippedVertical,
  }) {
    return ImageGameObject(
      key: key ?? this.key,
      name: name ?? this.name,
      position: position ?? this.position,
      scale: scale ?? this.scale,
      size: size ?? this.size,
      rotation: rotation ?? this.rotation,
      image: image,
      flippedHorizontal: flippedHorizontal ?? this.flippedHorizontal,
      flippedVertical: flippedVertical ?? this.flippedVertical,
    );
  }

  final _emptyPaint = Paint();

  late final _scaledSize = image.size / 64;

  @override
  void draw(Canvas canvas, Size size) {
    // super.draw(canvas, size);
    canvas.translate(position.x, position.y);
    canvas.rotate(rotation);
    canvas.scale(scale);

    canvas.scale(
      (flippedHorizontal ? -1 : 1),
      (flippedVertical ? -1 : 1),
    );

    canvas.translate(-position.x, -position.y);

    canvas.translate(
        position.x - this.size.x / 2, position.y - this.size.y / 2);

    canvas.scale(
      (this.size.x / 64) / _scaledSize.x,
      (this.size.y / 64) / _scaledSize.y,
    );

    canvas.drawImage(image, Offset.zero, _emptyPaint);
  }

  @override
  String getName() => name;

  @override
  List<String>? get previousMustBePlaced => [];
}
