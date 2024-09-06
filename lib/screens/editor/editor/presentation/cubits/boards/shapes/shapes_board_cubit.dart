import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flags/domain/editor/shapes/shape.dart';
import 'package:flags/screens/editor/editor/presentation/controllers/factories/boards/shapes_board.dart';
import 'package:flutter/material.dart';

part 'shapes_board_state.dart';

class ShapesBoardCubit extends Cubit<ShapesBoardState> {
  ShapesBoardCubit()
      : super(
          ShapesBoardState(
            items: ShapesBoardFactory.create(),
          ),
        );
}
