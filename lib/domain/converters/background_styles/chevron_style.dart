import 'dart:ui';

import 'package:flags/domain/editor/styles/chevron_style.dart';

import 'flag_style_serializer.dart';

final class ChevronStyleSerializer extends FlagStyleSerializer<ChevronStyle> {
  @override
  ChevronStyle factory({
    required Rect rect,
    required List<Color> colors,
  }) =>
      ChevronStyle(
        rect: rect,
        colors: colors,
      );
}
