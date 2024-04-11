import 'package:flags/domain/game_objects/game_objects.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';

import '../../../../domain/entities/path/path.dart';

class ColoredPart extends PathGameObject {
  ColoredPart({
    super.key,
    required super.name,
    required super.path,
    super.uniqueName,
    super.position,
    super.scale,
    super.size,
    super.rotation,
    super.previousMustBePlaced,
    required this.colors,
  });

  final List<Color> colors;

  @override
  ColoredPart copyWith({
    Key? key,
    String? name,
    String? uniqueName,
    Vector2? position,
    double? scale,
    Vector2? size,
    double? rotation,
    SPath? path,
    List<Color>? colors,
  }) {
    return ColoredPart(
      key: key ?? this.key,
      name: name ?? this.name,
      uniqueName: uniqueName ?? this.uniqueName,
      position: position ?? this.position,
      scale: scale ?? this.scale,
      size: size ?? this.size,
      rotation: rotation ?? this.rotation,
      path: path ?? this.path,
      previousMustBePlaced: previousMustBePlaced,
      colors: colors ?? this.colors,
    );
  }
}
