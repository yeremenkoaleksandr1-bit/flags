import 'dart:ui';

import 'package:flags/domain/editor/styles/border_style.dart';

import 'flag_style_serializer.dart';

final class BorderStyleSerializer extends FlagStyleSerializer<BorderStyle> {
  @override
  BorderStyle factory({
    required Rect rect,
    required List<Color> colors,
  }) =>
      BorderStyle(
        rect: rect,
        colors: colors,
      );
}
