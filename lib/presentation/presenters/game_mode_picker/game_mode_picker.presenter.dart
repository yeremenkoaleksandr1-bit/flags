import 'package:flags/domain/domain.dart';

import 'package:flags/presentation/presenters/continents_picker/route_params.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract interface class IGameModePickerCubit
    extends StateStreamableSource<dynamic> {
  void onGameModePicked(GameProcessType mode);
}

class GameModePickerCubitImpl extends Cubit<dynamic>
    implements IGameModePickerCubit {
  GameModePickerCubitImpl() : super(null);

  @override
  void onGameModePicked(GameProcessType mode) {
    // QR.toName(
    //   Routes.continentsPicker,
    //   params: {
    //     'data': ContinentPickerRouteParams(
    //       gameProcessType: mode,
    //     ),
    //   },
    // );
  }
}
