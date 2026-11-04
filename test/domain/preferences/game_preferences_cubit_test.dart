import 'dart:convert';

import 'package:flags/domain/models/game/scores/win_streak.dart';
import 'package:flags/domain/preferences/game_preferences.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('GamePreferencesCubit', () {
    test('loads persisted values and saves updates', () async {
      SharedPreferences.setMockInitialValues({
        'moneys': 10,
        'winStreak': jsonEncode(
          const WinStreak(
            currentStreak: 2,
            longestStreak: 4,
          ).toJson(),
        ),
      });

      final prefs = await SharedPreferences.getInstance();
      final cubit = GamePreferencesCubit(prefs);

      expect(cubit.state.moneys, 10);
      expect(cubit.state.winStreak.currentStreak, 2);
      expect(cubit.state.winStreak.longestStreak, 4);

      cubit.addMoney(5);
      cubit.recordWin();
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.moneys, 15);
      expect(cubit.state.winStreak.currentStreak, 3);
      expect(prefs.getInt('moneys'), 15);

      final savedWinStreak = WinStreak.fromJsonSafe(
        jsonDecode(prefs.getString('winStreak')!) as Map<String, dynamic>,
      );
      expect(savedWinStreak.currentStreak, 3);
      expect(savedWinStreak.longestStreak, 4);

      await cubit.close();
    });
  });
}
