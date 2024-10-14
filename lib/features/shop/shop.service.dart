import 'package:hive/hive.dart';

abstract interface class IShopService {
  bool isBought(String tag);

  void saveItem(String tag);
}

class ShopServiceImpl implements IShopService {
  static const String boxKey = "37f8792f-28cd-4368-8484-47ff24c12888";
  final Box<bool> box = Hive.box<bool>(name: boxKey);

  @override
  bool isBought(String item) {
    return box.containsKey(item);
  }

  @override
  void saveItem(String item) {
    box.put(item, true);
  }
}
