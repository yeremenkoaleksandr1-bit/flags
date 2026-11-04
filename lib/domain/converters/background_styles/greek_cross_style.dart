import 'dart:ui';

import 'package:flags/domain/editor/styles/greek_cross_style.dart';

import 'flag_style_serializer.dart';

final class GreekCrossStyleSerializer
    extends FlagStyleSerializer<GreekCrossStyle> {
  @override
  GreekCrossStyle factory({
    required Rect rect,
    required List<Color> colors,
  }) =>
      GreekCrossStyle(
        rect: rect,
        colors: colors,
      );
}
