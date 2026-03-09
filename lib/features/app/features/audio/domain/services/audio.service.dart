import 'package:flags/features/app/features/audio/domain/sound_data.dart';
import 'package:flags/shared/services/disposable.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _soundMuteKey = "settings.audio.muted";

abstract class IAudioService implements IDisposable {
  ValueNotifier<bool> get muted;

  Future<void> toggleMute();

  Future<void> playSfx(GameSfx source, {double volume = 1});

  Future<void> playBgm(GameMusics source, {double volume = 0.9});

  Future<void> pauseBgm();

  Future<void> resumeBgm();
}

class AudioServiceImpl implements IAudioService {
  final SharedPreferences _preferences;
  final Future<void> _bgmInitialization;

  GameMusics? _currentBgm;

  @override
  late final ValueNotifier<bool> muted;

  bool get isMuted => muted.value;

  AudioServiceImpl(
    this._preferences, {
    bool initialMuted = false,
  }) : _bgmInitialization = FlameAudio.bgm.initialize() {
    muted = ValueNotifier(_preferences.getBool(_soundMuteKey) ?? initialMuted);
  }

  @override
  Future<void> playBgm(
    GameMusics source, {
    double volume = 0.9,
  }) async {
    await _bgmInitialization;
    _currentBgm = source;

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
    await _bgmInitialization;

    if (_currentBgm == null) {
      return;
    }

    await FlameAudio.bgm.pause();
  }

  @override
  Future<void> resumeBgm() async {
    await _bgmInitialization;

    if (_currentBgm == null || isMuted) {
      return;
    }

    await FlameAudio.bgm.resume();
  }

  @override
  Future<void> playSfx(
    GameSfx source, {
    double volume = 1,
  }) async {
    if (isMuted) {
      return;
    }

    final normalizedVolume = volume.clamp(0.0, 1.0);
    await FlameAudio.play(
      source.file,
      volume: normalizedVolume,
    );
  }

  @override
  Future<void> toggleMute() async {
    muted.value = !isMuted;
    await _preferences.setBool(_soundMuteKey, isMuted);

    if (_currentBgm == null) {
      return;
    }

    if (isMuted) {
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
