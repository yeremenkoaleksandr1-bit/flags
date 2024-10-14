import 'package:flags/core/utils/utils.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/boards/custom_paint/custom_paint_cubit.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:memoize/memoize.dart';

import '../base/flippable.dart';

class DrawnGameObject extends FlippableGameObject {
  final CustomPaintState pathsHistory;

  DrawnGameObject({
    super.key,
    required super.name,
    super.position,
    super.scale,
    super.size,
    super.rotation,
    required this.pathsHistory,
    super.flippedHorizontal,
    super.flippedVertical,
  });

  Rect get bounds => pathsHistory.currentPath.bounds;

  final _cachedRect = memo1(RectX.fromSize);

  @override
  void draw(Canvas canvas, Size size) {
    canvas.scale(
      this.size.x / (64 * 5.6),
      this.size.y / (64 * 5.6),
    );

    canvas.clipRect(
      _cachedRect(
        const Size.square(64 * 5.6),
      ),
    );
    for (final path in pathsHistory.paths) {
      canvas.save();
      path.draw(canvas, size);
      canvas.restore();
    }
  }

  @override
  DrawnGameObject copyWith({
    Key? key,
    String? name,
    String? uniqueName,
    Vector2? position,
    double? scale,
    Vector2? size,
    double? rotation,
    CustomPaintState? pathsHistory,
    bool? flippedHorizontal,
    bool? flippedVertical,
  }) {
    return DrawnGameObject(
      key: key ?? this.key,
      name: name ?? this.name,
      position: position ?? this.position,
      scale: scale ?? this.scale,
      size: size ?? this.size,
      rotation: rotation ?? this.rotation,
      pathsHistory: pathsHistory ?? this.pathsHistory,
      flippedHorizontal: flippedHorizontal ?? this.flippedHorizontal,
      flippedVertical: flippedVertical ?? this.flippedVertical,
    );
  }

  @override
  Future<void> init() async => this;

  @override
  List<String>? get previousMustBePlaced => [];
}
