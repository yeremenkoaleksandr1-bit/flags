import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:games_services/games_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flags/features/app/features/auth/presentation/bloc/game_services_auth_state.dart';

final class GameServicesAuthCubit extends Cubit<GameServicesAuthState> {
  GameServicesAuthCubit(this._prefs)
    : super(
        GameServicesAuthState(
          isLoading: false,
          player: _readCachedPlayer(_prefs),
          statusMessage: null,
        ),
      ) {
    _playerSubscription = GameAuth.player.listen(_onPlayerChanged);
  }

  static const String _playerPrefsKey = 'game_services.player';

  final SharedPreferences _prefs;
  late final StreamSubscription<PlayerData?> _playerSubscription;

  static GameServicesPlayer? _readCachedPlayer(SharedPreferences prefs) {
    final raw = prefs.getString(_playerPrefsKey);
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      return GameServicesPlayer.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> signIn() async {
    emit(
      state.copyWith(
        isLoading: true,
        clearStatusMessage: true,
      ),
    );

    try {
      final result = await GameAuth.signIn();

      emit(
        state.copyWith(
          isLoading: false,
          statusMessage: result,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          statusMessage: error.toString(),
        ),
      );
    }
  }

  void _onPlayerChanged(PlayerData? playerData) {
    if (playerData == null) {
      _prefs.remove(_playerPrefsKey);
      emit(
        state.copyWith(
          isLoading: false,
          clearPlayer: true,
        ),
      );
      return;
    }

    final player = GameServicesPlayer(
      playerId: playerData.playerID ?? 'hidden_by_privacy_settings',
      displayName: playerData.displayName,
      iconImageBase64: playerData.iconImage,
    );

    _prefs.setString(_playerPrefsKey, jsonEncode(player.toJson()));

    emit(
      state.copyWith(
        isLoading: false,
        player: player,
        clearStatusMessage: true,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _playerSubscription.cancel();
    await super.close();
  }
}
