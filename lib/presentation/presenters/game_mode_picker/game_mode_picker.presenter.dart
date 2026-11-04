
import 'package:flutter_bloc/flutter_bloc.dart';

abstract interface class IGameModePickerCubit
    extends StateStreamableSource<dynamic> {

}

class GameModePickerCubitImpl extends Cubit<dynamic>
    implements IGameModePickerCubit {
  GameModePickerCubitImpl() : super(null);

}
