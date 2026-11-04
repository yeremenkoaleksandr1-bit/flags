import 'package:equatable/equatable.dart';
import 'package:flags/domain/models/game/scores/win_streak.dart';

class GamePreferencesState extends Equatable {
  const GamePreferencesState({
    required this.moneys,
    required this.winStreak,
  });

  final int moneys;
  final WinStreak winStreak;

  Map<String, dynamic> toJson() => {
        'moneys': moneys,
        'winStreak': winStreak.toJson(),
      };

  factory GamePreferencesState.fromJson(Map<String, dynamic> json) {
    return GamePreferencesState(
      moneys: json['moneys'],
      winStreak: WinStreak.fromJsonSafe(
        json['winStreak'],
      ),
    );
  }

  GamePreferencesState copyWith({
    int? moneys,
    WinStreak? winStreak,
  }) {
    return GamePreferencesState(
      moneys: moneys ?? this.moneys,
      winStreak: winStreak ?? this.winStreak,
    );
  }


  @override
  List<Object?> get props => [
        moneys,
        winStreak,
      ];
}
