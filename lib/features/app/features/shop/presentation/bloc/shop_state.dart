part of 'shop_cubit.dart';

@immutable
sealed class ShopState {}

final class ShopInitial extends ShopState {}

final class ShopUpdated extends ShopState {
  ShopUpdated(this.tag);

  final String tag;
}
