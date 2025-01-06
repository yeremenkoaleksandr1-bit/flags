part of 'audio_cubit.dart';

final class AudioState extends Equatable {
  final bool muted;
  final bool paused;

  const AudioState({
    required this.muted,
    required this.paused,
  });

  AudioState copyWith({
    bool? muted,
    bool? paused,
  }) {
    return AudioState(
      muted: muted ?? this.muted,
      paused: paused ?? this.paused,
    );
  }

  @override
  List<Object?> get props => [muted, paused];

}
