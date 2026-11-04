import 'dart:ui';

import 'package:flags/domain/editor/styles/saltire_style.dart';

import 'flag_style_serializer.dart';

final class SaltireStyleSerializer extends FlagStyleSerializer<SaltireStyle> {
  @override
  SaltireStyle factory({
    required Rect rect,
    required List<Color> colors,
  }) =>
      SaltireStyle(
        rect: rect,
        colors: colors,
      );
}
