import 'dart:ui';

import 'package:flags/domain/editor/styles/bends_style.dart';

import 'flag_style_serializer.dart';

final class BendsStyleSerializer extends FlagStyleSerializer<BendsStyle> {
  @override
  BendsStyle factory({
    required Rect rect,
    required List<Color> colors,
  }) =>
      BendsStyle(
        rect: rect,
        colors: colors,
      );
}
