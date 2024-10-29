import 'dart:io';

import 'package:flags/core/extensions/image.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/widgets.dart';

import '../base/flippable.dart';

class ImageGameObject extends FlippableGameObject {
  final String imagePath;

  late Image _imageFile;
  late UIImage? _image = null;

  ImageGameObject({
    super.key,
    super.uniqueName,
    required this.imagePath,
    required super.name,
    super.position,
    super.scale,
    super.size,
    super.rotation,
    super.flippedHorizontal,
    super.flippedVertical,
  }) {
    print(imagePath);
  }

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
      uniqueName: uniqueName ?? this.uniqueName,
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

  @override
  void draw(Canvas canvas, Size size) {
    if (_image != null) {
      late final scaledSize = _image!.size / 64;

      canvas.scale(
        (this.size.x / 64) / scaledSize.x,
        (this.size.y / 64) / scaledSize.y,
      );

      canvas.drawImage(_image!, Offset.zero, _emptyPaint);
    }
  }

  @override
  List<String>? get previousMustBePlaced => [];
}
