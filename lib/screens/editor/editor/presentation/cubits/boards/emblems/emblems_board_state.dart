part of 'emblems_board_cubit.dart';

final class EmblemsBoardState extends Equatable {
  final List<ClosedEmblemItem> items;

  const EmblemsBoardState({
    required this.items,
  });

  @override
  List<Object?> get props => [items];
}
