import 'dart:ui';

import '../../../uikit/uikit.dart';

enum GameDifficult {
  superEasy,
  easy,
  medium,
  hard,
  extraHard,
}

extension GameDifficultColor on GameDifficult {
  Color get color => switch (this) {
        GameDifficult.superEasy => ThemePalette.green,
        GameDifficult.easy => ThemePalette.yellow,
        GameDifficult.medium => const Color(0xffFC9D23),
        GameDifficult.hard => ThemePalette.red,
        GameDifficult.extraHard => const Color(0xffE4392B),
      };
}
