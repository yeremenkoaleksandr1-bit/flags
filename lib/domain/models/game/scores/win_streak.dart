import 'package:armar/armar.dart';
import 'package:hive/hive.dart';

class WinStreak {
  WinStreak({
    int currentStreak = 0,
    int longestStreak = 0,
  })  : currentStreakRx = RxValue(currentStreak),
        longestStreakRx = RxValue(longestStreak);

  final RxValue<int> currentStreakRx;
  final RxValue<int> longestStreakRx;

  void recordWin() {
    currentStreakRx.value++;
    if (currentStreakRx.value > longestStreakRx.value) {
      longestStreakRx.value = currentStreakRx.value;
    }
  }

  void resetStreak() {
    currentStreakRx.value = 0;
  }

  int getCurrentStreak() {
    return currentStreakRx.value;
  }

  int getLongestStreak() {
    return longestStreakRx.value;
  }

  Map<String, dynamic> toJson() {
    return {
      'currentStreak': currentStreakRx.value,
      'longestStreak': longestStreakRx.value,
    };
  }

  factory WinStreak.fromJson(Map<String, dynamic> map) {
    return WinStreak(
      currentStreak: map['currentStreak'] as int,
      longestStreak: map['longestStreak'] as int,
    );
  }

  static void registerAdapter() => Hive.registerAdapter(
        "WinStreak",
        (json) => WinStreak.fromJson(json),
      );
}
