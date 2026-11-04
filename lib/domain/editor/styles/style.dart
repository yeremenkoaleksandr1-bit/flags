import 'dart:ui';

import 'package:flags/domain/entities/path/path.dart';
import 'package:flags/domain/interfaces/drawable/i_drawable.dart';

abstract class FlagStyle implements IDrawable {
  final Rect rect;
  final List<SPath> paths;
  final List<Color> colors;

  FlagStyle({
    required this.colors,
    required this.rect,
    required List<SPath> Function(Rect rect) paths,
  }) : paths = paths(rect);

  FlagStyle copyWith({
    Rect? rect,
    List<Color>? colors,
  });

  FlagStyle changeColor(int index, Color color) {
    final colors = [...this.colors];
    colors[index] = color;
    return copyWith(colors: colors);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FlagStyle &&
          runtimeType == other.runtimeType &&
          rect == other.rect &&
          paths == other.paths;

  @override
  int get hashCode => rect.hashCode ^ paths.hashCode;

  @override
  void draw(Canvas canvas, Size size) {
    for (final path in paths) {
      canvas.save();
      canvas.translate(path.rect.left, path.rect.top);
      path.draw(canvas, size);
      canvas.restore();
    }
  }
}
