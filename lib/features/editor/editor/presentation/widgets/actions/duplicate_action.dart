import 'package:community_material_icon/community_material_icon.dart';
import 'package:flags/features/editor/editor/presentation/cubits/scene_objects/scene_objects_cubit.dart';
import 'package:flags/features/editor/editor/presentation/cubits/selected_object/selected_object_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'action_button.dart';

final class DuplicateObjectAction extends EditorActionButton {
  const DuplicateObjectAction(super.object, {super.key});

  @override
  void onPressed(
    BuildContext context,
    EditorSceneObjectsCubit bloc,
    EditorActionButtonState state,
  ) {
    final newObject = bloc.duplicate(gameObject);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (newObject != null) {
        final selectObjectBloc = context.read<EditorSelectedObjectCubit>();

        selectObjectBloc.selectObject(newObject);
      }
    });
  }

  @override
  Widget buildView(BuildContext context, EditorSceneObjectsCubit bloc) {
    return const Icon(CommunityMaterialIcons.content_duplicate);
  }
}
