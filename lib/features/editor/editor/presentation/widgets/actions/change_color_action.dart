import 'package:flags/domain/game_objects/shape/shape_object.dart';
import 'package:flags/features/editor/editor/presentation/cubits/scene_objects/scene_objects_cubit.dart';
import 'package:flags/features/editor/editor/presentation/cubits/selected_object/selected_object_cubit.dart';
import 'package:flags/features/editor/editor/presentation/dialogs/color_picker/color_picker_dialog.dart';
import 'package:flags/features/editor/editor/presentation/widgets/flag_style_color_changer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'action_button.dart';

final class ChangeColorAction extends EditorActionButton {
  const ChangeColorAction(super.object, {super.key});

  @override
  ShapeGameObject get gameObject => super.gameObject as ShapeGameObject;

  @override
  Future<void> onPressed(
    BuildContext context,
    EditorSceneObjectsCubit bloc,
    EditorActionButtonState state,
  ) async {
    final newColor =
        await showColorPickerDialog(context, gameObject.path.color);

    if (newColor != null) {
      final newObject = bloc.updateGameObject(
        gameObject.copyWith(
          key: UniqueKey(),
          path: gameObject.path.copyWith(
            paint: gameObject.path.paint.copyWith(
              color: newColor,
            ),
          ),
        ),
      );
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (newObject != null) {
          final selectObjectBloc = context.read<EditorSelectedObjectCubit>();
          await Future.delayed(const Duration());
          selectObjectBloc.selectObject(newObject);
        }
      });
    }
  }

  @override
  Widget buildView(BuildContext context, EditorSceneObjectsCubit bloc) {
    return ColorCircleView(gameObject.path.color, dimension: 12);
  }
}
