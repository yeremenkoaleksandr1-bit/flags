part of 'vibration_cubit.dart';

class VibrationState extends Equatable {
  final bool muted;

  const VibrationState({
    required this.muted,
  });

  VibrationState copyWith({
    bool? muted,
  }) {
    return VibrationState(
      muted: muted ?? this.muted,
    );
  }

  @override
  List<Object?> get props => [
        muted,
      ];
}
