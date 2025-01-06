import 'dart:convert';

import 'package:flags/domain/models/app/app.dart';
import 'package:flags/domain/models/game/scores/win_streak.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GamePreferences extends Cubit<GamePreferencesState> {
  late final SharedPreferences prefs;

  GamePreferences(this.prefs) : super(_loadState(prefs)) {
    super.stream.listen((state) => _saveState(prefs, state));
  }

  static GamePreferencesState _loadState(SharedPreferences prefs) =>
      GamePreferencesState(
        moneys: prefs.getInt('moneys') ?? 0,
        winStreak: WinStreak.fromJsonSafe(
          jsonDecode(
            prefs.getString('winStreak') ?? '{}',
          ),
        ),
      );

  static void _saveState(SharedPreferences prefs, GamePreferencesState state) {
    prefs.setInt('moneys', state.moneys);
    prefs.setString(
      'winStreak',
      jsonEncode(
        state.winStreak.toJson(),
      ),
    );
  }

  void addMoney(int value) {
    emit(
      state.copyWith(
        moneys: state.moneys + value,
      ),
    );
  }

  void recordWin() {
    emit(
      state.copyWith(
        winStreak: state.winStreak.recordWin(),
      ),
    );
  }

  void resetStreak() {
    emit(
      state.copyWith(
        winStreak: state.winStreak.resetStreak(),
      ),
    );
  }
}
