import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flags/domain/game_objects/emblems/emblem.dart';
import 'package:flags/screens/editor/editor/presentation/controllers/factories/boards/emblems_factory.dart';

part 'emblems_board_state.dart';

class EmblemsBoardCubit extends Cubit<EmblemsBoardState> {
  EmblemsBoardCubit()
      : super(
          EmblemsBoardState(
            items: EmblemsFactory.create(),
          ),
        );
}
