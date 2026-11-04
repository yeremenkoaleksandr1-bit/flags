import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'game_state_state.dart';

class GameStateCubit extends Cubit<GameStateState> {
  GameStateCubit()
      : super(
          const GameStateState(
            openedEmblems: [],
          ),
        );
}
