part of 'shapes_board_cubit.dart';

final class ShapesBoardState extends Equatable {
  final Map<String, SShape> items;

  const ShapesBoardState({
    required this.items,
  });

  @override
  List<Object?> get props => [items];
}
