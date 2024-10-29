import 'dart:ui';

import 'package:flags/domain/editor/styles/czech_style.dart';

import 'flag_style_serializer.dart';

final class CzechStyleSerializer extends FlagStyleSerializer<CzechStyle> {
  @override
  CzechStyle factory({
    required Rect rect,
    required List<Color> colors,
  }) =>
      CzechStyle(
        rect: rect,
        colors: colors,
      );
}
