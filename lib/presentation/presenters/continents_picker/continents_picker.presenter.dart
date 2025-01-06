import 'package:bloc_utils/bloc_utils.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/prefabs/levels/levels.dart';
import 'package:flags/presentation/presenters/continents_picker/route_params.dart';
import 'package:flags/presentation/presenters/continents_picker/state/continents_picker.state.dart';
import 'package:flame/extensions.dart';

abstract interface class IContinentsPickerCubit
    with DynamicStatedCubitStream<ContinentsPickerState> {
  void onContinentSelected(ContinentType continent);

  void onPlayFastMode();
}

class ContinentsPickerCubitImpl extends StatedCubit<ContinentsPickerState>
    implements IContinentsPickerCubit {
  final ContinentPickerRouteParams routeParams;

  ContinentsPickerCubitImpl({required this.routeParams});

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

    emit(
      SuccessState(
        ContinentsPickerState(
          continents: continents,
        ),
      ),
    );

    super.onInit();
  }

  @override
  void onContinentSelected(ContinentType continent) {
    // QR.toName(
    //   Routes.levelsPicker,
    //   params: {
    //     'data': LevelsPickerRouteParams(
    //       gameProcessType: routeParams.gameProcessType,
    //       continentType: continent,
    //     ),
    //   },
    // );
  }

  @override
  Future<void> onPlayFastMode() async {
    final continent = [...ContinentType.values].random();

    final levels = FactoryGameContinent().create(continent);

    // QR.toName(
    //   Routes.gameProcessFactory,
    //   params: {
    //     'data': GamesFactoryPageParams(
    //       level: levels.levels.random,
    //       difficult: [...GameDifficult.values].random,
    //       gamesType: GameStyleType.fast,
    //       gameMode: routeParams.gameProcessType,
    //       continentType: continent,
    //     ),
    //   },
    // );
  }
}
