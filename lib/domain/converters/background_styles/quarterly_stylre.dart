import 'dart:ui';

import 'package:flags/domain/editor/styles/quarterly_stylre.dart';

import 'flag_style_serializer.dart';

final class QuarterlyStyleSerializer
    extends FlagStyleSerializer<QuarterlyStyle> {
  @override
  QuarterlyStyle factory({
    required Rect rect,
    required List<Color> colors,
  }) =>
      QuarterlyStyle(
        rect: rect,
        colors: colors,
      );
}
