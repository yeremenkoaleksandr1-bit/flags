import 'package:flags/shared/services/disposable.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

class WinStreak implements IDisposable {
  WinStreak({
    int currentStreak = 0,
    int longestStreak = 0,
  })  : currentStreakRx = ValueNotifier(currentStreak),
        longestStreakRx = ValueNotifier(longestStreak);

  final ValueNotifier<int> currentStreakRx;
  final ValueNotifier<int> longestStreakRx;

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

  @override
  void dispose() {
    currentStreakRx.dispose();
    longestStreakRx.dispose();
  }
}
