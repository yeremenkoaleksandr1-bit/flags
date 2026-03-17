import 'package:defer_pointer/defer_pointer.dart';
import 'package:flags/domain/game_objects/base/flippable.dart';
import 'package:flags/domain/game_objects/game_objects.dart';
import 'package:flags/domain/game_objects/shape/shape_object.dart';
import 'package:flags/features/editor/editor/custom_defer_pointer/defer_pointer.dart';
import 'package:flags/features/editor/editor/presentation/cubits/selected_object/selected_object_cubit.dart';
import 'package:flags/features/editor/editor/presentation/widgets/actions/flip_horizontal_action.dart';
import 'package:flags/features/editor/editor/presentation/widgets/actions/layer_down_action.dart';
import 'package:flags/features/editor/editor/presentation/widgets/actions/layer_up_action.dart';
import 'package:flags/features/editor/editor/presentation/widgets/actions/toggle_magnet_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'change_color_action.dart';
import 'duplicate_action.dart';
import 'flip_vertical_action.dart';
import 'remove_object_action.dart';

class EditorSelectedObjectActionsBuilder extends StatelessWidget {
  const EditorSelectedObjectActionsBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return EDeferredPointerHandler(
      child: BlocBuilder<EditorSelectedObjectCubit, EditorSelectedObjectState>(
        builder: (BuildContext context, EditorSelectedObjectState state) {
          final object = state.object;

          return Wrap(
            spacing: 4.w,
            runSpacing: 4.h,
            children: [
              const ToggleMagnetAction(),
              if (object != null) ...[
                if (object.gameObject is! ImageGameObject)
                  DuplicateObjectAction(object),
                LayerUpAction(object),
                LayerDownAction(object),
                if (object.gameObject is FlippableGameObject) ...[
                  FlipVerticalAction(object),
                  FlipHorizontalAction(object),
                ],
                if (object.gameObject is ImageGameObject) ...<dynamic>[],
                if (object.gameObject is ShapeGameObject) ...[
                  ChangeColorAction(object),
                ],
                RemoveObjectAction(object),
              ],
            ].map((e) => DeferPointer(child: e)).toList(),
          );
        },
      ),
    );
  }
}
