import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/domain/editor/shapes/shape.dart';
import 'package:flags/domain/game_objects/game_objects.dart';
import 'package:flags/screens/editor/editor/presentation/bloc/flag_editor_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/boards/shapes/shapes_board_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/scene_objects/scene_objects_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/views/boards/base_board.dart';
import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flags/uikit/painters/drawable_painter.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../uikit/layout_components/containers/containers.dart';

class ShapesBoard extends EditorBaseBoard {
  ShapesBoard({super.key})
      : super(
          buildWhen: (p, c) {
            return p.isOpenedShapesBoard != c.isOpenedShapesBoard;
          },
        );

  @override
  bool getState(FlagEditorState state) {
    return state.isOpenedShapesBoard;
  }

  @override
  void onBackgroundTapped(IFlagEditorCubit bloc) {
    bloc.toggleShapesBoardOpen(false);
  }

  @override
  Positioned buildWidget(BuildContext context, BoxConstraints constraints) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      top: constraints.biggest.height / 2,
      child: Material(
        type: MaterialType.card,
        color: Colors.transparent,
        child: build(context),
      ),
    );
  }

  Widget build(BuildContext context) {
    final editorBloc = context.read<IFlagEditorCubit>();
    final sceneObjectsBloc = context.read<EditorSceneObjectsCubit>();
    final cubit = context.read<ShapesBoardCubit>();

    void onSelected(SShape value) {
      editorBloc.toggleShapesBoardOpen(false);
      sceneObjectsBloc.addGameObject(
        PathGameObject(
          name: UniqueKey().toString(),
          path: value,
        ),
      );
    }

    return FCard(
      child: BlocBuilder<ShapesBoardCubit, ShapesBoardState>(
        builder: (context, state) {
          return GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            children: [
              ...state.items.entries.map(
                (e) => ScaledGestureDetector(
                  onTap: () => onSelected(e.value),
                  child: FCard(
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const Pad(all: 12),
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: SizedBox.fromSize(
                                size: e.value.rect.size,
                                child: DrawablePaint(
                                  drawable: e.value,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Text(e.key),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
