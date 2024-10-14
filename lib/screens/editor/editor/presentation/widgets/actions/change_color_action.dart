import 'package:flags/domain/game_objects/game_objects.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/scene_objects/scene_objects_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/widgets/flag_style_color_changer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'action_button.dart';

final class ChangeColorAction extends EditorActionButton {
  const ChangeColorAction(super.object, {super.key});

  @override
  PathGameObject get gameObject => super.gameObject as PathGameObject;

  @override
  void onPressed(BuildContext context, EditorSceneObjectsCubit bloc) {
    // TODO: implement onPressed
  }

  @override
  Widget buildView(BuildContext context, EditorSceneObjectsCubit bloc) {
    return ColorCircleView(gameObject.color, dimension: 12);
  }
}
