import 'dart:ui';

import 'package:flags/domain/editor/styles/pall_style.dart';

import 'flag_style_serializer.dart';

final class PallStyleSerializer extends FlagStyleSerializer<PallStyle> {
  @override
  PallStyle factory({
    required Rect rect,
    required List<Color> colors,
  }) =>
      PallStyle(
        rect: rect,
        colors: colors,
      );
}
