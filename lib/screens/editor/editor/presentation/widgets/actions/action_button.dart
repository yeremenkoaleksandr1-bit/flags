import 'package:flags/domain/game_objects/base/game_object.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/scene_objects/scene_objects_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/object_handles/editor_draggable.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class EditorActionButton extends StatefulWidget {
  const EditorActionButton(this.object, {super.key});

  final EditorDraggableWidget object;

  GameObject get gameObject => object.gameObject;

  void onPressed(
    BuildContext context,
    EditorSceneObjectsCubit bloc,
    EditorActionButtonState state,
  );

  Widget buildView(BuildContext context, EditorSceneObjectsCubit bloc);

  Color buildButtonColor(BuildContext context) {
    return ThemePalette.peachCard;
  }

  @override
  State<EditorActionButton> createState() => EditorActionButtonState();
}

class EditorActionButtonState extends State<EditorActionButton> {
  late final bloc = context.read<EditorSceneObjectsCubit>();

  @override
  Widget build(BuildContext context) {
    return FButton(
      color: widget.buildButtonColor(context),
      onPressed: () => widget.onPressed(context, bloc, this),
      child: SizedBox.square(
        dimension: 24,
        child: widget.buildView(context, bloc),
      ),
    );
  }
}
