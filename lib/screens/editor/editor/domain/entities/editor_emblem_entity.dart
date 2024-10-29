import 'package:equatable/equatable.dart';

base class EditorEmblemEntity extends Equatable {
  final String name;

  const EditorEmblemEntity({
    required this.name,
  });

  @override
  List<Object?> get props => [
        name,
      ];
}

final class EditorBuyableEmblemEntity extends EditorEmblemEntity {
  final int price;

  const EditorBuyableEmblemEntity({
    required super.name,
    required this.price,
  });
}

final class EditorGameEmblemEntity extends EditorEmblemEntity {
  final bool isOpened;

  const EditorGameEmblemEntity({
    required super.name,
    required this.isOpened,
  });

  @override
  List<Object?> get props => [
        name,
        isOpened,
      ];
}
