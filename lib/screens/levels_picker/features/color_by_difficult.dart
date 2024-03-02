import 'dart:ui';

import 'package:flags/domain/domain.dart';

import '../../../uikit/theme/palette.dart';

Color getColorByDifficult(GameDifficult difficult) {
  return switch (difficult) {
    GameDifficult.superEasy => ThemePalette.green,
    GameDifficult.easy => ThemePalette.gentleYellow,
    GameDifficult.medium => ThemePalette.yellow,
    GameDifficult.hard => ThemePalette.red,
    GameDifficult.extraHard => ThemePalette.redAccent,
  };
}
