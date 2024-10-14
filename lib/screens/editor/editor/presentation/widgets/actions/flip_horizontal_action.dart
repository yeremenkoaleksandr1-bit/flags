import 'package:community_material_icon/community_material_icon.dart';
import 'package:flags/domain/game_objects/base/flippable.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/scene_objects/scene_objects_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'action_button.dart';

final class FlipHorizontalAction extends EditorActionButton {
  const FlipHorizontalAction(super.object, {super.key});

  @override
  FlippableGameObject get gameObject => super.gameObject as FlippableGameObject;

  @override
  void onPressed(BuildContext context, EditorSceneObjectsCubit bloc) {
    bloc.flipHorizontal(gameObject);
  }

  @override
  Widget buildView(BuildContext context, EditorSceneObjectsCubit bloc) {
    return const Icon(CommunityMaterialIcons.flip_horizontal);
  }
}
