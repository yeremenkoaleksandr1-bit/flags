import 'package:flags/features/app/features/audio/domain/sound_data.dart';
import 'package:flags/shared/services/disposable.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _soundMuteKey = "settings.audio.muted";

abstract class IAudioService implements IDisposable {
  ValueNotifier<bool> get muted;

  Future<void> toggleMute();

  Future<void> playSfx(GameSfx source, {double volume = 1.25});

  Future<void> playBgm(GameMusics source, {double volume = 0.9});

  Future<void> pauseBgm();

  Future<void> resumeBgm();
}

class AudioServiceImpl implements IAudioService {
  final SharedPreferences _preferences;

  @override
  late final ValueNotifier<bool> muted;

  bool get isMuted => muted.value;

  AudioServiceImpl(
    this._preferences, {
    bool initialMuted = false,
  }) {
    muted = ValueNotifier(_preferences.getBool(_soundMuteKey) ?? initialMuted);

    FlameAudio.bgm.initialize();
  }

  @override
  Future<void> playBgm(
    GameMusics source, {
    double volume = 0.9,
  }) async {
    await FlameAudio.bgm.play(
      source.file,
      volume: volume,
    );

    if (isMuted) {
      await pauseBgm();
    }
  }

  @override
  Future<void> pauseBgm() async {
    await FlameAudio.bgm.pause();
  }

  @override
  Future<void> resumeBgm() async {
    await FlameAudio.bgm.resume();
  }

  @override
  Future<void> playSfx(
    GameSfx source, {
    double volume = 1.25,
  }) async {
    // if (muted.value) {
    //   return;
    // }
    await FlameAudio.play(
      source.file,
      volume: volume,
    );
  }

  @override
  Future<void> toggleMute() async {
    muted.value = !isMuted;
    await _preferences.setBool(_soundMuteKey, isMuted);

    if (isMuted && FlameAudio.bgm.isPlaying) {
      await pauseBgm();
    } else {
      await resumeBgm();
    }
  }

  @override
  void dispose() {
    muted.dispose();
  }
}
