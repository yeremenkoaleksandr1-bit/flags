import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:flags/domain/preferences/game_preferences.dart';
import 'package:flags/features/app/features/shop/domain/services/shop.service.dart';
import 'package:flags/features/app/features/shop/domain/shop.item.dart';
import 'package:meta/meta.dart';

part 'shop_state.dart';

abstract interface class IShopCubit extends StateStreamableSource<ShopState> {
  void buiItem(String tag);

  bool isBought(String tag);

  bool canBuy(String tag);

  int getPrice(String tag);
}

class ShopCubit extends Cubit<ShopState> implements IShopCubit {
  final GamePreferencesCubit gamePreferences;

  final List<ShopItem> buyableItems;

  final IShopService service;

  ShopCubit({
    required this.gamePreferences,
    required this.buyableItems,
    required this.service,
  }) : super(ShopInitial());

  @override
  void buiItem(String tag) {
    if (!service.isBought(tag) && canBuy(tag)) {
      gamePreferences.removeMoney(getPrice(tag));
      service.saveItem(tag);
    }
  }

  @override
  bool canBuy(String tag) {
    return gamePreferences.state.moneys - getPrice(tag) >= 0;
  }

  @override
  int getPrice(String tag) {
    return buyableItems.firstWhereOrNull((e) => e.tag == tag)?.price ?? -1;
  }

  @override
  bool isBought(String tag) {
    return service.isBought(tag);
  }
}
