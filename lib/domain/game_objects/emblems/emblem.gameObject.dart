import 'dart:ui' as ui;

import 'package:flags/resources/resources.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/widgets.dart';

import '../../game_objects/base/flippable.dart';
import 'emblem.dart';

class EmblemPart extends FlippableGameObject {
  EmblemPart({
    super.key,
    required this.emblem,
    String? name,
    super.position,
    super.scale,
    super.size,
    super.rotation,
    super.flippedHorizontal,
    super.flippedVertical,
    super.uniqueName,
    super.previousMustBePlaced,
    Vector2? initialEmblemSize,
  })  : initialEmblemSize = initialEmblemSize ?? Vector2.zero(),
        super(name: name ?? emblem.name);

  Vector2 initialEmblemSize;

  final Emblem emblem;

  @override
  Future<EmblemPart> init() async {
    initialEmblemSize = emblem.image.size;

    return copyWith(
      emblem: emblem,
      size: emblem.image.size,
    );
  }

  static EmblemPart fromType<T extends Emblem>({
    Key? key,
    String? uniqueName,
    String? name,
    Vector2? position,
    Vector2? size,
    double scale = 1,
    double rotation = 0,
    Emblem? emblem,
    bool flippedHorizontal = false,
    bool flippedVertical = false,
    List<String>? previousMustBePlaced,
  }) {
    final resource = Resources.i.emblemsResources.getEmblemByType<T>();
    return EmblemPart(
      emblem: resource,
      key: key,
      name: name,
      uniqueName: uniqueName,
      position: position,
      scale: scale,
      size: size,
      rotation: rotation,
      flippedHorizontal: flippedHorizontal,
      flippedVertical: flippedVertical,
      previousMustBePlaced: previousMustBePlaced,
    );
  }

  late final _scaledSize = emblem.image.size;

  @override
  void draw(ui.Canvas canvas, ui.Size size) {
    canvas.scale(
      this.size.x / _scaledSize.x,
      this.size.y / _scaledSize.y,
    );
    emblem.draw(canvas, size);
  }

  @override
  EmblemPart copyWith({
    Key? key,
    String? name,
    Vector2? position,
    double? scale,
    Vector2? size,
    double? rotation,
    Emblem? emblem,
    bool? flippedHorizontal,
    bool? flippedVertical,
    List<String>? previousMustBePlaced,
    String? uniqueName,
  }) {
    return EmblemPart(
      key: key ?? this.key,
      name: name ?? this.name,
      uniqueName: this.uniqueName ?? uniqueName,
      emblem: emblem ?? this.emblem,
      position: position ?? this.position,
      scale: scale ?? this.scale,
      size: size ?? this.size,
      rotation: rotation ?? this.rotation,
      flippedHorizontal: flippedHorizontal ?? this.flippedHorizontal,
      flippedVertical: flippedVertical ?? this.flippedVertical,
      previousMustBePlaced: previousMustBePlaced ?? this.previousMustBePlaced,
    )..initialEmblemSize = initialEmblemSize;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      super == other &&
          other is EmblemPart &&
          runtimeType == other.runtimeType &&
          emblem == other.emblem;

  @override
  int get hashCode => super.hashCode ^ emblem.hashCode;
}
