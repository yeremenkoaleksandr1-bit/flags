import 'package:flags/features/app/features/vibration/presentation/bloc/vibration_cubit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Вибрация при проигрыше в играх на флагах (мс).
const int kFlagGameLoseVibrationMs = 300;

/// Вибрация при ударе падающего блока в Камбодже (мс).
const int kCambodiaHitVibrationMs = 60;

/// Вибрирует через общий сервис (учитывает настройку вибрации) и пишет в лог
/// строку с меткой `[Vibration]` — для проверки, что событие сработало.
void flagGameVibrate(
  BuildContext context,
  String game,
  String event, {
  int ms = kFlagGameLoseVibrationMs,
}) {
  final vibration = context.read<IVibrationCubit>();
  debugPrint(
    '[Vibration] $game: $event, ${ms}ms'
    '${vibration.state.muted ? ' (skipped: vibration is off in settings)' : ''}',
  );
  vibration.vibrate(milliseconds: ms);
}
