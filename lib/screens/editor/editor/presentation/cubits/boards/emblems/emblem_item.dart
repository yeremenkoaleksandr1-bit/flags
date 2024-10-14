import 'package:equatable/equatable.dart';
import 'package:flags/domain/game_objects/emblems/emblem.dart';

sealed class EmblemItem extends Equatable {
  final Emblem emblem;

  const EmblemItem({required this.emblem});

  @override
  List<Object?> get props => [
        emblem,
      ];
}

final class ClosedEmblemItem extends EmblemItem {
  const ClosedEmblemItem({
    required super.emblem,
  });
}

final class OpenedEmblemItem extends EmblemItem {
  const OpenedEmblemItem({
    required super.emblem,
  });
}

final class BuyableEmblemItem extends EmblemItem {
  final int price;

  const BuyableEmblemItem(
    this.price, {
    required super.emblem,
  });
}
