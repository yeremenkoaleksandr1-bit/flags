part of 'magnet_area_cubit.dart';

final class MagnetAreaState extends Equatable {
  final bool active;
  final bool activeHorizontalPosition;
  final bool activeVerticalPosition;

  const MagnetAreaState({
    required this.active,
    required this.activeHorizontalPosition,
    required this.activeVerticalPosition,
  });

  @override
  List<Object?> get props => [
        active,
        activeHorizontalPosition,
        activeVerticalPosition,
      ];

  MagnetAreaState copyWith({
    bool? active,
    bool? activeHorizontalPosition,
    bool? activeVerticalPosition,
  }) {
    return MagnetAreaState(
      active: active ?? this.active,
      activeHorizontalPosition:
          activeHorizontalPosition ?? this.activeHorizontalPosition,
      activeVerticalPosition:
          activeVerticalPosition ?? this.activeVerticalPosition,
    );
  }
}
