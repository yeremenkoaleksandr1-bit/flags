import 'package:equatable/equatable.dart';
import 'package:flags/shared/services/disposable.dart';
import 'package:flutter/cupertino.dart';

class WinStreak extends Equatable {
  const WinStreak({
    required this.currentStreak,
    required this.longestStreak,
  });

  final int currentStreak;
  final int longestStreak;

  WinStreak recordWin() {
    final currentStreak = this.currentStreak + 1;
    return copyWith(
      currentStreak: currentStreak,
      longestStreak:
          currentStreak > longestStreak ? currentStreak : longestStreak,
    );
  }

  WinStreak resetStreak() {
    return copyWith(
      currentStreak: 0,
    );
  }

  int getCurrentStreak() {
    return currentStreak;
  }

  int getLongestStreak() {
    return longestStreak;
  }

  Map<String, dynamic> toJson() {
    return {
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
    };
  }

  factory WinStreak.fromJsonSafe(Map<String, dynamic> map) {
    return WinStreak(
      currentStreak: map['currentStreak'] ?? 0,
      longestStreak: map['longestStreak'] ?? 0,
    );
  }

  WinStreak copyWith({
    int? currentStreak,
    int? longestStreak,
  }) {
    return WinStreak(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
    );
  }

  @override
  List<Object?> get props => [
        currentStreak,
        longestStreak,
      ];
}
