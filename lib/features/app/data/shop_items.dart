import 'package:flags/features/app/features/shop/domain/shop.item.dart';
import 'package:flags/resources/resources.dart';

final List<ShopItem> shopItemsData = [
  const ShopItem(tag: 'continent_1', price: 150),
  const ShopItem(tag: 'continent_2', price: 250),
  const ShopItem(tag: 'continent_3', price: 250),
  const ShopItem(tag: 'continent_4', price: 250),
  const ShopItem(tag: 'continent_5', price: 600),
  const ShopItem(tag: 'editor.custom_paint', price: 1000),
  const ShopItem(tag: 'editor.upload_custom_image', price: 1000),
  ...Resources.i.emblemsResources.emblems.map(
    (e) => ShopItem(
      tag: "emblem_${e.name}",
      price: 200,
    ),
  ),
];
