import 'dart:ui';

import 'package:flags/domain/editor/styles/canton_style.dart';

import 'flag_style_serializer.dart';

final class CantonStyleSerializer extends FlagStyleSerializer<CantonStyle> {
  @override
  CantonStyle factory({
    required Rect rect,
    required List<Color> colors,
  }) =>
      CantonStyle(
        rect: rect,
        colors: colors,
      );
}
