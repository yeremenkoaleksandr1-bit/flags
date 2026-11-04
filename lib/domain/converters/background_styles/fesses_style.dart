import 'dart:ui';

import 'package:flags/domain/editor/styles/fesses_style.dart';

import 'flag_style_serializer.dart';

final class FessesStyleSerializer extends FlagStyleSerializer<FessesStyle> {
  @override
  FessesStyle factory({
    required Rect rect,
    required List<Color> colors,
  }) =>
      FessesStyle(
        rect: rect,
        colors: colors,
      );
}
