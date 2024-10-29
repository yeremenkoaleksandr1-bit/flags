import 'dart:ui';

import 'package:flags/domain/editor/styles/pales_style.dart';

import 'flag_style_serializer.dart';

final class PalesStyleSerializer extends FlagStyleSerializer<PalesStyle> {
  @override
  PalesStyle factory({
    required Rect rect,
    required List<Color> colors,
  }) =>
      PalesStyle(
        rect: rect,
        colors: colors,
      );
}
