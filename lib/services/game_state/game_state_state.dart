part of 'game_state_cubit.dart';

@immutable
final class GameStateState extends Equatable {
  final List<String> openedEmblems;

  const GameStateState({
    required this.openedEmblems,
  });

  GameStateState copyWith({
    List<String>? openedEmblems,
  }) {
    return GameStateState(
      openedEmblems: openedEmblems ?? this.openedEmblems,
    );
  }

  @override
  List<Object?> get props => [
        openedEmblems,
      ];
}
