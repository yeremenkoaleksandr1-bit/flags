import 'package:armar/armar.dart';
import 'package:flags/features/audio/audio.service.dart';
import 'package:flags/features/audio/sound_data.dart';
import 'package:flutter/material.dart';

class AudioProvider extends StatefulWidget {
  const AudioProvider({
    super.key,
    required this.child,
  });

  final Widget child;

  static IAudioController of(BuildContext context) {
    final instance = context.findAncestorStateOfType<_AudioProviderState>();
    assert(instance != null, "Cannot find IAudioController in current context");

    return instance!;
  }

  @override
  State<AudioProvider> createState() => _AudioProviderState();
}

abstract interface class IAudioController {
  RxValue<bool> get muted;

  Future<void> toggleMute();

  Future<void> playSfx(GameSfx source, {double volume = 1});

  Future<void> playBgm(GameMusics source, {double volume = 1});

  Future<void> pauseBgm();

  Future<void> resumeBgm();
}

class _AudioProviderState extends State<AudioProvider>
    implements IAudioController {
  final IAudioService audioService = AudioServiceImpl();

  @override
  Future<void> pauseBgm() => audioService.pauseBgm();

  @override
  Future<void> playBgm(GameMusics source, {double volume = 1}) =>
      audioService.playBgm(source, volume: volume);

  @override
  Future<void> playSfx(GameSfx source, {double volume = 1}) =>
      audioService.playSfx(source, volume: volume);

  @override
  Future<void> resumeBgm() => audioService.resumeBgm();

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  RxValue<bool> get muted => audioService.muted;

  @override
  Future<void> toggleMute() => audioService.toggleMute();
}
