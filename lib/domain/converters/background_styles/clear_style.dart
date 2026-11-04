import 'dart:ui';

import 'package:flags/domain/editor/styles/clear_style.dart';

import 'flag_style_serializer.dart';

final class ClearStyleSerializer extends FlagStyleSerializer<ClearStyle> {
  @override
  ClearStyle factory({
    required Rect rect,
    required List<Color> colors,
  }) =>
      ClearStyle(
        rect: rect,
        colors: colors,
      );
}
