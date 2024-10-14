import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flags/logger.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

part 'area_state.dart';

class EditorAreaCubit extends Cubit<EditorAreaState> {
  EditorAreaCubit()
      : super(
          const EditorAreaState(
            rect: Rect.zero,
          ),
        );

  double get fraction => state.rect.width / 64;

  void setAreaRect(Rect rect) {
    emit(
      state.copyWith(rect: rect),
    );
  }
}
