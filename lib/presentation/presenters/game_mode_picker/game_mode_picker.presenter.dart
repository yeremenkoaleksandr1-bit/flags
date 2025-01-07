import 'package:flags/domain/domain.dart';

import 'package:flags/presentation/presenters/continents_picker/route_params.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract interface class IGameModePickerCubit
    extends StateStreamableSource<dynamic> {

}

class GameModePickerCubitImpl extends Cubit<dynamic>
    implements IGameModePickerCubit {
  GameModePickerCubitImpl() : super(null);

}
