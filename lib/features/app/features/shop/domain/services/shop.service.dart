import 'package:shared_preferences/shared_preferences.dart';

abstract interface class IShopService {
  bool isBought(String tag);

  void saveItem(String tag);
}

class ShopServiceImpl implements IShopService {
  final SharedPreferences _prefs;

  ShopServiceImpl(this._prefs);

  @override
  bool isBought(String item) {
    return _prefs.containsKey('shop.$item');
  }

  @override
  void saveItem(String item) {
    _prefs.setBool('shop.$item', true);
  }
}
