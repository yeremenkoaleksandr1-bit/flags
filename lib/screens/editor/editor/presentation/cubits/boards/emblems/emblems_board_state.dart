part of 'emblems_board_cubit.dart';

final class EmblemsBoardState extends Equatable {
  final List<Emblem> items;

  const EmblemsBoardState({
    required this.items,
  });

  @override
  List<Object?> get props => [items];
}
