import 'package:collection/collection.dart';
import 'package:flags/features/shop/shop.service.dart';
import 'package:flags/presentation/app/app.presenter.dart';
import 'package:flags/resources/resources.dart';
import 'package:flutter/widgets.dart';

import 'shop.item.dart';

class ShopProvider extends StatefulWidget {
  const ShopProvider({
    super.key,
    required this.child,
  });

  final Widget child;

  static IShopController of(BuildContext context) {
    final instance = context.findAncestorStateOfType<_ShopProviderState>();
    assert(instance != null, "Cannot find IShopController in current context");

    return instance!;
  }

  @override
  State<ShopProvider> createState() => _ShopProviderState();
}

abstract interface class IShopController {
  void buiItem(String tag);

  bool isBought(String tag);

  bool canBuy(String tag);

  int getPrice(String tag);
}

class _ShopProviderState extends State<ShopProvider>
    implements IShopController {
  final gameState = IAppPresenter.I.gameState;

  final IShopService service = ShopServiceImpl();

  final List<ShopItem> _items = [
    ShopItem(tag: 'continent_1', price: 1000),
    ShopItem(tag: 'continent_2', price: 1000),
    ShopItem(tag: 'continent_3', price: 1000),
    ShopItem(tag: 'continent_4', price: 1000),
    ShopItem(tag: 'continent_5', price: 1000),
    ...Resources.i.emblemsResources.emblems.map(
      (e) => ShopItem(
        tag: "emblem_${e.name}",
        price: 0,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void buiItem(String tag) {
    if (!service.isBought(tag) && canBuy(tag)) {
      gameState.addMoney(-getPrice(tag));
      service.saveItem(tag);
    }
  }

  @override
  bool isBought(String tag) => service.isBought(tag);

  @override
  int getPrice(String tag) {
    return _items.firstWhereOrNull((e) => e.tag == tag)?.price ?? -1;
  }

  @override
  bool canBuy(String tag) {
    return gameState.data.money - getPrice(tag) >= 0;
  }
}
