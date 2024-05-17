import 'package:flags/domain/domain.dart';
import 'package:flags/prefabs/levels/levels.dart';
import 'package:flags/presentation/navigator/routes.dart';
import 'package:flags/presentation/presenters/continents_picker/route_params.dart';
import 'package:flags/presentation/presenters/continents_picker/state/continents_picker.state.dart';
import 'package:flags/presentation/presenters/levels_picker/route_params.dart';
import 'package:flags/screens/games/games_factory.page.dart';
import 'package:qlevar_router/qlevar_router.dart';
import 'package:state_manager/state_manager.dart';

abstract interface class IContinentsPickerPresenter
    with StateMixin<ContinentsPickerState> {
  static IContinentsPickerPresenter get i =>
      Get.find<IContinentsPickerPresenter>(tag: "single");

  void onContinentSelected(ContinentType continent);

  void onPlayFastMode();
}

class ContinentsPickerPresenterImpl extends GetxController
    with StateMixin<ContinentsPickerState>
    implements IContinentsPickerPresenter {
  final ContinentPickerRouteParams routeParams;

  ContinentsPickerPresenterImpl({required this.routeParams});

  @override
  Future<void> onInit() async {
    final continents = [
      ContinentType.europe,
      ContinentType.asia,
      ContinentType.africa,
      ContinentType.southAmerica,
      ContinentType.northAmerica,
      ContinentType.oceania,
    ];

    change(
      SuccessStatus(
        ContinentsPickerState(
          continents: continents,
        ),
      ),
    );

    super.onInit();
  }

  @override
  void onContinentSelected(ContinentType continent) {
    QR.toName(
      Routes.levelsPicker,
      params: {
        'data': LevelsPickerRouteParams(
          gameProcessType: routeParams.gameProcessType,
          continentType: continent,
        ),
      },
    );
  }

  @override
  Future<void> onPlayFastMode() async {
    final continent = [...ContinentType.values].random;

    final levels = FactoryGameContinent().create(continent);

    QR.toName(
      Routes.gameProcessFactory,
      params: {
        'data': GamesFactoryPageParams(
          level: levels.levels.random,
          difficult: [...GameDifficult.values].random,
          gamesType: GameStyleType.fast,
          gameMode: routeParams.gameProcessType,
          continentType: continent,
        ),
      },
    );
  }
}
