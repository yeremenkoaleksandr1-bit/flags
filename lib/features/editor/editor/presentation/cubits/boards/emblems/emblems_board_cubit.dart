import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flags/domain/game_objects/emblems/emblem.gameObject.dart';
import 'package:flags/features/app/features/shop/presentation/bloc/shop_cubit.dart';
import 'package:flags/features/editor/editor/presentation/controllers/factories/boards/emblems_factory.dart';
import 'package:flags/features/editor/editor/presentation/cubits/boards/emblems/emblem_item.dart';
import 'package:flags/prefabs/levels/levels.dart';
import 'package:flags/features/app/presentation/bloc/app_cubit.dart';

part 'emblems_board_state.dart';

/// ВРЕМЕННО для тестов: все эмблемы открыты. Покупки и открытия
/// не трогаются — false вернёт всё как было.
const bool kUnlockAllEmblemsForTesting = true;

class EmblemsBoardCubit extends Cubit<EmblemsBoardState> {
  final IAppCubit appCubit;
  final IShopCubit shopCubit;

  EmblemsBoardCubit(
    this.appCubit,
    this.shopCubit,
  ) : super(
          const EmblemsBoardState(
            items: [],
          ),
        ) {
    _prepare();
  }

  void _prepare() {
    final emblems = EmblemsFactory.create().toList();

    // закрытые: не открыты сборкой флага и не куплены ранее
    final closedEmblemsItems = emblems
        .where(
          (e) =>
              !kUnlockAllEmblemsForTesting &&
              !appCubit.emblemsService.isOpened(e.name) &&
              !shopCubit.isBought("emblem_${e.name}"),
        )
        .toList();

    final openedEmblems = emblems
        .where(
          (e) =>
              kUnlockAllEmblemsForTesting ||
              appCubit.emblemsService.isOpened(e.name) ||
              shopCubit.isBought("emblem_${e.name}"),
        )
        .map(
          (e) => OpenedEmblemItem(
            emblem: e,
          ),
        )
        .toList();

    // эмблемы, которые выдаются за сборку флагов в пазлах
    final gameEmblemItems = FactoryGameContinent.continents.values
        .expand((e) => e.levels.map((e) => e.flag))
        .expand((e) => e.objects.whereType<EmblemPart>())
        .map((e) => e.name.toLowerCase())
        .toSet();

    final gameEmblems = closedEmblemsItems
        .where(
          (e) {
            final value = gameEmblemItems.contains(
              e.name.toLowerCase(),
            );

            return value;
          },
        )
        .map(
          (e) => GameEmblemItem(emblem: e),
        )
        .toList();

    // платные — только эмблемы, которых нет ни на одном флаге; остальные
    // открываются исключительно сборкой своего флага
    final closedEmblems = closedEmblemsItems
        .where((e) => !gameEmblemItems.contains(e.name.toLowerCase()))
        .map(
          (e) => BuyableEmblemItem(
            price: shopCubit.getPrice("emblem_${e.name}"),
            emblem: e,
          ),
        )
        .toList();

    emit(
      EmblemsBoardState(
        items: [
          ...openedEmblems
            ..sort(
              (a, b) => a.emblem.name.toLowerCase().compareTo(
                    b.emblem.name.toLowerCase(),
                  ),
            ),
          ...gameEmblems
            ..sort(
              (a, b) => a.emblem.name.toLowerCase().compareTo(
                    b.emblem.name.toLowerCase(),
                  ),
            ),
          ...closedEmblems
            ..sort(
              (a, b) => a.emblem.name.toLowerCase().compareTo(
                    b.emblem.name.toLowerCase(),
                  ),
            ),
        ],
      ),
    );
  }

  void buyEmblem(EmblemItem item) {
    final tagItem = "emblem_${item.emblem.name}";

    if (shopCubit.canBuy(tagItem)) {
      shopCubit.buiItem(tagItem);

      final objects = [...state.items];

      final index = objects.indexOf(item);

      if (index != -1) {
        objects[index] = OpenedEmblemItem(emblem: item.emblem);
      }

      emit(
        EmblemsBoardState(
          items: objects,
        ),
      );
    }
  }
}
