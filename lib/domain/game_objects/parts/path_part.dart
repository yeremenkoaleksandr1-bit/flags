// ignore_for_file: must_be_immutable
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

import '../../../core/elements/paint.dart';
import '../../../core/path_drawing/path_drawing.dart';
import '../../../core/utils/utils.dart';
import '../../entities/path/path.dart';
import '../base/process.game_object.dart';

class PathGameObject extends ProcessGameObject {
  final SPath path;

  PathGameObject({
    super.key,
    required super.name,
    super.uniqueName,
    required this.path,
    super.position,
    super.scale,
    super.size,
    super.rotation,
    this.previousMustBePlaced,
  });

  @override
  final List<String>? previousMustBePlaced;

  @override
  Vector2 get size => path.bounds.size.toVector2();

  Rect get bounds => path.bounds;

  Color get color => path.paint.color;

  factory PathGameObject.rect({
    required String name,
    String? uniqueName,
    required Vector2 size,
    required Vector2 position,
    required Color color,
    PaintingStyle style = PaintingStyle.fill,
    List<String>? mustBePlaced,
  }) {
    return PathGameObject(
      name: name,
      uniqueName: uniqueName,
      path: SPath.rect(
        paint: SPaint(
          color: color,
          style: style,
        ),
        rect: position & size,
      ),
      previousMustBePlaced: mustBePlaced,
    );
  }

  factory PathGameObject.fromSvgPath(
    String path, {
    required String name,
    String? uniqueName,
    Vector2? Function(Rect bounds)? position,
    required Vector2 areaSize,
    Vector2? visualSize,
    required Color color,
    PaintingStyle style = PaintingStyle.fill,
    double strokeWidth = 1,
    bool canScale = false,
    List<String>? previousMustBePlaced,
  }) {
    final data = parseSvgPathModel(
      path,
      paint: SPaint(
        color: color,
        style: style,
        strokeWidth: strokeWidth,
      ),
    );

    final object = PathGameObject(
      key: UniqueKey(),
      name: name,
      uniqueName: uniqueName,
      position: position?.call(data.bounds) ?? Vector2.zero(),
      size: areaSize,
      path: data,
      previousMustBePlaced: previousMustBePlaced,
    );

    if (canScale) {
      return object.copyWith(
        scale: Calculator.fraction(
          visualSize!.toSize(),
          areaSize.toSize(),
        ),
      );
    }

    return object;
  }

  @override
  void draw(Canvas canvas, Size size, [double fraction = 1]) {
    drawPart(canvas, size);
  }

  void drawPart(Canvas canvas, Size size) {
    super.draw(canvas, size);

    // canvas.scale(
    //   size.width / path.bounds.width,
    //   size.height / path.bounds.height,
    // );

    path.draw(canvas, size);
  }

  bool equalTo(PathGameObject instance) {
    return instance.name == name;
  }

  @override
  Future<void> init() async => this;

  @override
  PathGameObject copyWith({
    Key? key,
    String? name,
    String? uniqueName,
    Vector2? position,
    double? scale,
    Vector2? size,
    double? rotation,
    SPath? path,
  }) {
    SPath? path0;

    if (size != null) {
      path0 = this.path.copyWith(rect: size.toRect());
    }

    return PathGameObject(
      key: key ?? this.key,
      name: name ?? this.name,
      uniqueName: uniqueName ?? this.uniqueName,
      position: position ?? this.position,
      scale: scale ?? this.scale,
      size: size ?? this.size,
      rotation: rotation ?? this.rotation,
      path: path ?? (path0 ?? this.path),
      previousMustBePlaced: previousMustBePlaced,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is PathGameObject &&
        runtimeType == other.runtimeType &&
        key == other.key &&
        name == other.name &&
        uniqueName == other.uniqueName &&
        position == other.position &&
        scale == other.scale &&
        size == other.size &&
        rotation == other.rotation &&
        path == other.path;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      name.hashCode ^
      uniqueName.hashCode ^
      position.hashCode ^
      scale.hashCode ^
      size.hashCode ^
      rotation.hashCode ^
      path.hashCode;
}
