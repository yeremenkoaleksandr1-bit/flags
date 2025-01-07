import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:vibration/vibration.dart';

part 'vibration_state.dart';

abstract interface class IVibrationCubit
    extends StateStreamableSource<VibrationState> {
  Future<void> toggleMute();

  Future<void> vibrate({int milliseconds = 150});
}

class VibrationCubit extends Cubit<VibrationState> implements IVibrationCubit {
  final SharedPreferences prefs;

  VibrationCubit(this.prefs)
      : super(
          VibrationState(
            muted: prefs.getBool('settings.vibration.muted') ?? false,
          ),
        );

  @override
  Future<void> toggleMute() async {

    emit(
      state.copyWith(
        muted: !state.muted,
      ),
    );

    await prefs.setBool('settings.vibration.muted', state.muted);
  }

  @override
  Future<void> vibrate({int milliseconds = 150}) async {
    if (state.muted) {
      return;
    }
    try {
      await Vibration.vibrate(duration: milliseconds);
    } catch (e) {}
  }
}
