import 'dart:ui';

import 'package:flags/domain/editor/styles/bicolour_style.dart';

import 'flag_style_serializer.dart';

final class BicolourStyleSerializer extends FlagStyleSerializer<BicolourStyle> {
  @override
  BicolourStyle factory({
    required Rect rect,
    required List<Color> colors,
  }) =>
      BicolourStyle(
        rect: rect,
        colors: colors,
      );
}
