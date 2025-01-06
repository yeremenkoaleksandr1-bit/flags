import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'magnet_area_state.dart';

class MagnetAreaCubit extends Cubit<MagnetAreaState> {
  MagnetAreaCubit()
      : super(
          const MagnetAreaState(
            active: true,
            activeHorizontalPosition: false,
            activeVerticalPosition: false,
          ),
        );

  void setActiveStatus(bool value) {
    emit(
      state.copyWith(
        active: value,
      ),
    );
  }

  void setActiveRotationAngles(double angle) {}

  void setActiveHorizontalPosition(bool value) {
    if (state.activeHorizontalPosition != value) {
      emit(
        state.copyWith(
          activeHorizontalPosition: value,
        ),
      );
    }
  }

  void setActiveVerticalPosition(bool value) {
    if (state.activeVerticalPosition != value) {
      emit(
        state.copyWith(
          activeVerticalPosition: value,
        ),
      );
    }
  }
}
