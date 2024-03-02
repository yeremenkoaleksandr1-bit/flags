import 'package:flags/domain/models/app/app.dart';
import 'package:flags/domain/models/game/scores/win_streak.dart';
import 'package:hive/hive.dart';

class GamePreferences {
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

    data.winStreak.currentStreakRx.stream.listen((event) {
      box.put('currentStreak', event);
    });

    data.winStreak.longestStreakRx.stream.listen((event) {
      box.put('longestStreak', event);
    });

    data.moneyRx.stream.listen((event) {
      box.put('money', event);
    });
  }

  void setMoney(int value) {
    data.money = value;
  }

  void addMoney(int value) {
    data.money += value;
  }
}
