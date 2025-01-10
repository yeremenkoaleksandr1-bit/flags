import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flags/features/app/features/audio/domain/services/audio.service.dart';
import 'package:flags/features/app/features/audio/domain/sound_data.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';

part 'audio_state.dart';

abstract interface class IAudioCubit extends StateStreamableSource<AudioState> {
  Future<void> toggleMute();

  Future<void> playSfx(GameSfx source, {double volume = 1});

  Future<void> playBgm(GameMusics source, {double volume = 1});

  Future<void> pauseBgm();

  Future<void> resumeBgm();
}

class AudioCubit extends Cubit<AudioState> implements IAudioCubit {
  AudioCubit(SharedPreferences prefs)
      : audioService = AudioServiceImpl(prefs),
        super(
          AudioState(
            muted: prefs.getBool('settings.audio.muted') ?? false,
            paused: prefs.getBool('settings.audio.paused') ?? false,
          ),
        ) {
    audioService.muted.value = state.muted;
  }

  final IAudioService audioService;

  @override
  Future<void> playBgm(GameMusics source, {double volume = 1}) =>
      audioService.playBgm(source, volume: volume);

  @override
  Future<void> playSfx(GameSfx source, {double volume = 1}) =>
      audioService.playSfx(source, volume: volume);

  @override
  Future<void> resumeBgm() async {
    emit(
      state.copyWith(
        paused: false,
      ),
    );
    await audioService.resumeBgm();
  }

  @override
  Future<void> pauseBgm() async {
    emit(
      state.copyWith(
        paused: true,
      ),
    );
    await audioService.pauseBgm();
  }

  @override
  Future<void> toggleMute() async {
    emit(
      state.copyWith(
        muted: !state.muted,
      ),
    );

    await audioService.toggleMute();
  }
}
