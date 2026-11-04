part of 'styles_board_cubit.dart';

final class StylesBoardState extends Equatable {
  final Map<String, FlagStyle> items;

  const StylesBoardState({
    required this.items,
  });

  @override
  List<Object?> get props => [items];
}
