import 'dart:math';

import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/domain/game_objects/emblems/emblem.dart';
import 'package:flags/domain/game_objects/emblems/emblem.gameObject.dart';
import 'package:flags/features/editor/editor/presentation/bloc/flag_editor_cubit.dart';
import 'package:flags/features/editor/editor/presentation/cubits/boards/emblems/emblem_item.dart';
import 'package:flags/features/editor/editor/presentation/cubits/scene_objects/scene_objects_cubit.dart';
import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flags/uikit/layout_components/containers/card.dart';
import 'package:flags/uikit/painters/drawable_painter.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OpenedEmblemItemView extends StatelessWidget {
  const OpenedEmblemItemView(
    this.item, {
    super.key,
  });

  final EmblemItem item;

  Widget buildView(BuildContext context) {
    final editorBloc = context.read<IFlagEditorCubit>();

    final sceneObjectsBloc = context.read<EditorSceneObjectsCubit>();

    Future<void> onSelect(Emblem value) async {
      final size = value.image.size / 12;

      final effectiveSize = value.image.size / max(size.x, size.y);

      final part = EmblemPart(
        name: UniqueKey().toString(),
        emblem: value,
        initialEmblemSize: value.image.size,
        size: effectiveSize,
      );

      editorBloc.toggleEmblemsBoardOpen(false);
      sceneObjectsBloc.addGameObject(
        part,
      );
    }

    return ScaledGestureDetector(
      onTap: () => onSelect(item.emblem),
      child: FCard(
        color: ThemePalette.blue.brighten(.5),
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const Pad(all: 2),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: DrawablePaint(
                    drawable: item.emblem,
                    size: item.emblem.image.size.toSize(),
                  ),
                ),
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                item.emblem.name,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildView(context);
  }
}
