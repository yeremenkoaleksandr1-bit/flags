import 'package:flags/domain/models/app/app.dart';
import 'package:flags/domain/models/game/scores/win_streak.dart';
import 'package:flags/shared/services/disposable.dart';
import 'package:hive/hive.dart';

class GamePreferences implements IDisposable {
  late final GamePreferencesData data;
  final Box<dynamic> box = Hive.box<dynamic>(name: "game_preferences");

  GamePreferences() {
    data = GamePreferencesData(
      money: box.get('money') ?? 0,
      winStreak: WinStreak(
        currentStreak: box.get('currentStreak') ?? 0,
        longestStreak: box.get('longestStreak') ?? 0,
      ),
    );

    data.winStreak.currentStreakRx.addListener(() {
      box.put('currentStreak', data.winStreak.currentStreakRx.value);
    });

    data.winStreak.longestStreakRx.addListener(() {
      box.put('longestStreak', data.winStreak.longestStreakRx.value);
    });

    data.moneyRx.addListener(() {
      box.put('money', data.moneyRx.value);
    });
  }

  void setMoney(int value) {
    data.money = value;
  }

  void addMoney(int value) {
    data.money += value;
  }

  @override
  void dispose() {
    data.dispose();
  }
}
