import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flags/domain/game_objects/emblems/emblem.dart';
import 'package:flags/features/shop/shop.provider.dart';
import 'package:flags/screens/editor/editor/presentation/controllers/factories/boards/emblems_factory.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/boards/emblems/emblem_item.dart';

part 'emblems_board_state.dart';

class EmblemsBoardCubit extends Cubit<EmblemsBoardState> {
  final IShopController shop;

  EmblemsBoardCubit(this.shop)
      : super(
          EmblemsBoardState(
            items: [
              ...EmblemsFactory.create().map(
                (e) => ClosedEmblemItem(emblem: e),
              ),
            ],
          ),
        );

  void sortEmblems(List<Emblem> emblems, List<String> openedEmblems) {
    emblems.sort((emblem1, emblem2) {
      final isCustomEmblem1 = !state.items.contains(emblem1.name);
      final isCustomEmblem2 = !state.items.contains(emblem2.name);
      final isBought1 = shop.isBought(emblem1.name);
      final isBought2 = shop.isBought(emblem2.name);

      final opened1 = openedEmblems.contains(emblem1.name);
      final opened2 = openedEmblems.contains(emblem2.name);

      if (opened1 != opened2) {
        return opened1 ? -1 : 1;
      }

      if (isCustomEmblem1 != isCustomEmblem2) {
        return isCustomEmblem1 ? -1 : 1;
      }

      if (isBought1 != isBought2) {
        return isBought1 ? -1 : 1;
      }

      return emblem1.name.compareTo(emblem2.name);
    });
  }
}
