import 'dart:ui';

import 'package:flags/domain/editor/styles/scandinavian_cross_style.dart';

import 'flag_style_serializer.dart';

final class ScandinavianCrossStyleSerializer
    extends FlagStyleSerializer<ScandinavianCrossStyle> {
  @override
  ScandinavianCrossStyle factory({
    required Rect rect,
    required List<Color> colors,
  }) =>
      ScandinavianCrossStyle(
        rect: rect,
        colors: colors,
      );
}
