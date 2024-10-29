import 'package:community_material_icon/community_material_icon.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/scene_objects/scene_objects_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/selected_object/selected_object_cubit.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'action_button.dart';

final class RemoveObjectAction extends EditorActionButton {
  const RemoveObjectAction(super.object, {super.key});

  @override
  void onPressed(
    BuildContext context,
    EditorSceneObjectsCubit bloc,
    EditorActionButtonState state,
  ) {
    final selectCubit = context.read<EditorSelectedObjectCubit>();
    bloc.removeObject(gameObject);
    selectCubit.selectObject(null);
  }

  @override
  Color buildButtonColor(BuildContext context) {
    return ThemePalette.redButton;
  }

  @override
  Widget buildView(BuildContext context, EditorSceneObjectsCubit bloc) {
    return const Icon(
      CommunityMaterialIcons.delete,
      color: Colors.white,
    );
  }
}
