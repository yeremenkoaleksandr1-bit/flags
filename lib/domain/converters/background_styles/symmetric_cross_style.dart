import 'dart:ui';

import 'package:flags/domain/editor/styles/symmetric_cross_style.dart';

import 'flag_style_serializer.dart';

final class SymmetricCrossStyleSerializer
    extends FlagStyleSerializer<SymmetricCrossStyle> {
  @override
  SymmetricCrossStyle factory({
    required Rect rect,
    required List<Color> colors,
  }) =>
      SymmetricCrossStyle(
        rect: rect,
        colors: colors,
      );
}
