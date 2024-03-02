import 'package:armar/armar.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/presentation/navigator/routes.dart';
import 'package:flags/presentation/presenters/continents_picker/route_params.dart';
import 'package:flags/presentation/presenters/levels_picker/route_params.dart';
import 'package:qlevar_router/qlevar_router.dart';

import 'state/continents_picker.state.dart';

abstract interface class IContinentsPickerPresenter
    with StateMixin<ContinentsPickerState> {
  static IContinentsPickerPresenter get i =>
      Get.find<IContinentsPickerPresenter>(tag: "single");

  void onContinentSelected(ContinentType continent);
}

class ContinentsPickerPresenterImpl extends GetxController
    with StateMixin<ContinentsPickerState>
    implements IContinentsPickerPresenter {
  final ContinentPickerRouteParams routeParams;

  ContinentsPickerPresenterImpl({required this.routeParams});

  @override
  void onInit() async {
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
    QR.toName(Routes.levelsPicker, params: {
      'data': LevelsPickerRouteParams(
        gameProcessType: routeParams.gameProcessType,
        continentType: continent,
      ),
    });
  }
}
