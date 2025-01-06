import 'package:flags/domain/models/app/app.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final class AppPreferencesCubit extends Cubit<AppPreferencesData> {
  late final SharedPreferences _prefs;

  AppPreferencesCubit(this._prefs)
      : super(
          AppPreferencesData(
            activeSound: _prefs.getBool('activeSound') ?? true,
            activeVibration: _prefs.getBool('activeVibration') ?? true,
            isDebugMode: _prefs.getBool('isDebugMode') ?? false,
          ),
        );

  void setActiveSound(bool value) {
    emit(
      state.copyWith(
        activeSound: value,
      ),
    );
    _prefs.setBool('activeSound', value);
  }

  void setActiveVibration(bool value) {
    emit(
      state.copyWith(
        activeVibration: value,
      ),
    );

    _prefs.setBool('activeVibration', value);
  }

  void setDebugMode(bool value) {
    emit(
      state.copyWith(
        isDebugMode: value,
      ),
    );

    _prefs.setBool('isDebugMode', value);
  }
}
