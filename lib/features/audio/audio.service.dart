import 'package:armar/armar.dart';
import 'package:flags/features/audio/sound_data.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:hive/hive.dart';

const String _soundMuteKey = "94aa258bd3a5";

abstract class IAudioService {
  RxValue<bool> get muted;

  Future<void> toggleMute();

  Future<void> playSfx(GameSfx source, {double volume = 1});

  Future<void> playBgm(GameMusics source, {double volume = 1});

  Future<void> pauseBgm();

  Future<void> resumeBgm();
}

class AudioServiceImpl implements IAudioService {
  final Box<bool> _preferences = Hive.box(name: "preferences");

  @override
  late final RxValue<bool> muted;

  bool get isMuted => muted.value;

  AudioServiceImpl({
    bool initialMuted = false,
  }) {
    muted = RxValue(_preferences.get(_soundMuteKey) ?? initialMuted);

    FlameAudio.bgm.initialize();
  }

  @override
  Future<void> playBgm(
    GameMusics source, {
    double volume = 1,
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
    double volume = 1,
  }) async {
    if (muted.value) {
      return;
    }
    await FlameAudio.play(
      source.file,
      volume: volume,
    );
  }

  @override
  Future<void> toggleMute() async {
    muted.value = !isMuted;
    _preferences.put(_soundMuteKey, isMuted);

    if (isMuted && FlameAudio.bgm.isPlaying) {
      await pauseBgm();
    } else {
      await resumeBgm();
    }
  }
}
