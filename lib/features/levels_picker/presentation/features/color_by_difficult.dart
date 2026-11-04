import 'dart:ui';

import 'package:flags/domain/domain.dart';
import 'package:flags/uikit/uikit.dart';

Color getColorByDifficult(GameDifficult difficult) {
  return switch (difficult) {
    GameDifficult.superEasy => ThemePalette.greenButton,
    GameDifficult.easy => ThemePalette.yellowButton,
    GameDifficult.medium => ThemePalette.orangeButton,
    GameDifficult.hard => ThemePalette.redButton,
    GameDifficult.extraHard => ThemePalette.redDarkButton,
  };
}
