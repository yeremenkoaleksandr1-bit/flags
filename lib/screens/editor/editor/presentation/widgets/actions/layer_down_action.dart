import 'package:community_material_icon/community_material_icon.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/scene_objects/scene_objects_cubit.dart';
import 'package:flutter/material.dart';

import 'action_button.dart';

final class LayerDownAction extends EditorActionButton {
  const LayerDownAction(super.object, {super.key});

  @override
  void onPressed(BuildContext context, EditorSceneObjectsCubit bloc) {
    bloc.layerDown(gameObject);
  }

  @override
  Widget buildView(BuildContext context, EditorSceneObjectsCubit bloc) {
    return const Icon(CommunityMaterialIcons.arrange_send_backward);
  }
}
