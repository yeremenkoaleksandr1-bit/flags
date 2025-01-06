import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flags/domain/editor/styles/style.dart';
import 'package:flags/features/editor/editor/presentation/controllers/factories/boards/styles_board.dart';
import 'package:flutter/material.dart';

part 'styles_board_state.dart';

class StylesBoardCubit extends Cubit<StylesBoardState> {
  StylesBoardCubit(Rect flagRect)
      : super(
          StylesBoardState(
            items: StylesBoardFactory.create(flagRect),
          ),
        );
}
