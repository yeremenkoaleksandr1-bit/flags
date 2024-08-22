import 'package:state_manager/state_manager.dart';
import 'package:flags/domain/domain.dart';
import 'package:flags/presentation/navigator/routes.dart';
import 'package:flags/presentation/presenters/continents_picker/route_params.dart';
import 'package:qlevar_router/qlevar_router.dart';

abstract interface class IGameModePickerPresenter {
  static IGameModePickerPresenter get i =>
      Get.find<IGameModePickerPresenter>(tag: "single");

  void onGameModePicked(GameProcessType mode);
}

class GameModePickerPresenterImpl extends GetController
    implements IGameModePickerPresenter {
  @override
  void onGameModePicked(GameProcessType mode) {
    QR.toName(
      Routes.continentsPicker,
      params: {
        'data': ContinentPickerRouteParams(
          gameProcessType: mode,
        ),
      },
    );
  }
}
