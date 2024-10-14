import 'dart:io';

import 'package:flags/core/extensions/image.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/widgets.dart';

import '../base/flippable.dart';

class ImageGameObject extends FlippableGameObject {
  final String imagePath;

  late Image _imageFile;
  late UIImage _image;

  ImageGameObject({
    super.key,
    required this.imagePath,
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
    _imageFile = Image.file(File(imagePath));
    _image = await _imageFile.image.image;
    return this;
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
      imagePath: imagePath,
      flippedHorizontal: flippedHorizontal ?? this.flippedHorizontal,
      flippedVertical: flippedVertical ?? this.flippedVertical,
    );
  }

  final _emptyPaint = Paint();

  late final _scaledSize = _image.size / 64;

  @override
  void draw(Canvas canvas, Size size) {
    // super.draw(canvas, size);

    canvas.scale(
      (this.size.x / 64) / _scaledSize.x,
      (this.size.y / 64) / _scaledSize.y,
    );

    canvas.drawImage(_image, Offset.zero, _emptyPaint);

    canvas.scale(
      (flippedHorizontal ? -1 : 1),
      (flippedVertical ? -1 : 1),
    );
  }

  @override
  List<String>? get previousMustBePlaced => [];
}
