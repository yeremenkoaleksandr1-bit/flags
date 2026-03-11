import 'package:flags/domain/preferences/game_preferences.dart';
import 'package:flags/features/app/features/shop/domain/services/shop.service.dart';
import 'package:flags/features/app/features/shop/domain/shop.item.dart';
import 'package:flags/features/app/features/shop/presentation/bloc/shop_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ShopCubit', () {
    test('buys item only when enough money and not previously bought', () async {
      SharedPreferences.setMockInitialValues({
        'moneys': 100,
      });

      final prefs = await SharedPreferences.getInstance();
      final gamePreferences = GamePreferencesCubit(prefs);
      final cubit = ShopCubit(
        gamePreferences: gamePreferences,
        buyableItems: const [
          ShopItem(
            tag: 'pack',
            price: 30,
          ),
        ],
        service: ShopServiceImpl(prefs),
      );

      expect(cubit.canBuy('pack'), isTrue);
      expect(cubit.isBought('pack'), isFalse);

      cubit.buiItem('pack');
      await Future<void>.delayed(Duration.zero);

      expect(cubit.isBought('pack'), isTrue);
      expect(gamePreferences.state.moneys, 70);
      expect(prefs.getBool('shop.pack'), isTrue);

      cubit.buiItem('pack');
      await Future<void>.delayed(Duration.zero);

      expect(gamePreferences.state.moneys, 70);

      await cubit.close();
      await gamePreferences.close();
    });
  });
}
