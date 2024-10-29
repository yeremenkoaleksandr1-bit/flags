import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flags/domain/game_objects/emblems/emblem.gameObject.dart';
import 'package:flags/domain/services/game/emblems.service.dart';
import 'package:flags/features/shop/shop.provider.dart';
import 'package:flags/prefabs/levels/levels.dart';
import 'package:flags/screens/editor/editor/presentation/controllers/factories/boards/emblems_factory.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/boards/emblems/emblem_item.dart';

part 'emblems_board_state.dart';

class EmblemsBoardCubit extends Cubit<EmblemsBoardState> {
  final IShopController shop;

  EmblemsBoardCubit(this.shop)
      : super(
          const EmblemsBoardState(
            items: [],
          ),
        ) {
    _prepare();
  }

  void _prepare() {
    final emblems = EmblemsFactory.create().toList();

    final closedEmblemsItems = emblems
        .where(
          (e) => !IEmblemsService.I.isOpened(e.name),
        )
        .toList();

    final openedEmblems = emblems
        .where(
          (e) =>
              IEmblemsService.I.isOpened(e.name) ||
              shop.isBought("emblem_${e.name}"),
        )
        .map(
          (e) => OpenedEmblemItem(
            emblem: e,
          ),
        )
        .toList();

    final gameEmblemItems = FactoryGameContinent.continents.values
        .expand((e) => e.levels.map((e) => e.flag))
        .expand((e) => e.objects.whereType<EmblemPart>())
        .map((e) => e.name.toLowerCase());

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

    final closedEmblems = closedEmblemsItems
        .map(
          (e) => BuyableEmblemItem(
            price: shop.getPrice("emblem_${e.name}"),
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

    if (shop.canBuy(tagItem)) {
      shop.buiItem(tagItem);

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
