import 'package:equatable/equatable.dart';

class ShopItem extends Equatable {
  final String tag;
  final int price;

  const ShopItem({
    required this.tag,
    required this.price,
  });

  @override
  List<Object?> get props => [
        tag,
        price,
      ];
}
