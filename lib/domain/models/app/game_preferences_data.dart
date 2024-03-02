import 'package:armar/armar.dart';
import 'package:dart_numerics/dart_numerics.dart';
import 'package:flags/domain/models/game/scores/win_streak.dart';
import 'package:hive/hive.dart';

class GamePreferencesData {
  GamePreferencesData({
    required int money,
    required this.winStreak,
  }) : moneyRx = RxValue(money);

  final RxValue<int> moneyRx;

  int get money => moneyRx.value;

  set money(int value) {
    moneyRx.value = value.clamp(0, int64MaxValue);
  }

  final WinStreak winStreak;

  Map<String, dynamic> toJson() => {
        'money': money,
        'winStreak': winStreak.toJson(),
      };

  factory GamePreferencesData.fromJson(Map<String, dynamic> json) {
    return GamePreferencesData(
      money: json['money'],
      winStreak: WinStreak.fromJson(json['winStreak']),
    );
  }

  static void registerAdapter() => Hive.registerAdapter(
        "GamePreferences",
        (json) => GamePreferencesData.fromJson(json),
      );
}
