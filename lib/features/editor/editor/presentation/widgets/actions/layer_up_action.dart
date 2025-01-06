import 'package:community_material_icon/community_material_icon.dart';
import 'package:flags/features/editor/editor/presentation/cubits/scene_objects/scene_objects_cubit.dart';
import 'package:flutter/material.dart';

import 'action_button.dart';

final class LayerUpAction extends EditorActionButton {
  const LayerUpAction(super.object, {super.key});

  @override
  void onPressed(
    BuildContext context,
    EditorSceneObjectsCubit bloc,
    EditorActionButtonState state,
  ) {
    bloc.layerUp(gameObject);
  }

  @override
  Widget buildView(BuildContext context, EditorSceneObjectsCubit bloc) {
    return const Icon(CommunityMaterialIcons.arrange_bring_forward);
  }
}
