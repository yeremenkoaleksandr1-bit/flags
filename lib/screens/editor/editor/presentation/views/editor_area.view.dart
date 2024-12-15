import 'package:defer_pointer/defer_pointer.dart';
import 'package:drag_and_drop/extensions/render_box.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/area/area_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/magnet_area/magnet_area_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/scene_objects/scene_objects_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/views/area/background_style_view.dart';
import 'package:flags/screens/editor/editor/presentation/views/area/magnet_area_view.dart';
import 'package:flags/uikit/game_widgets/objects/game_objects_rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/flag_editor_cubit.dart';
import '../cubits/selected_object/selected_object_cubit.dart';

class EditorAreaView extends StatelessWidget {
  const EditorAreaView({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<IFlagEditorCubit>();
    final sceneObjectsCubit = context.read<EditorSceneObjectsCubit>();
    final selectedObjectCubit = context.read<EditorSelectedObjectCubit>();

    final areaCubit = context.read<EditorAreaCubit>();

    return Stack(
      fit: StackFit.passthrough,
      children: [
        RepaintBoundary(
          key: FlagEditorCubit.flagAreaKey,
          child: FittedBox(
            child: Builder(
              builder: (context) {
                SchedulerBinding.instance.addPostFrameCallback(
                  (_) {
                    final areaBound = context.globalPaintBounds;
                    if (areaBound != null) {
                      areaCubit.setAreaRect(areaBound);
                    }
                  },
                );
                return SizedBox(
                  width: 64,
                  child: AspectRatio(
                    aspectRatio: bloc.initialFlag.proportion,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        const Positioned.fill(
                          child: EditorBackgroundStyleView(),
                        ),
                        Positioned.fill(
                          child: GestureDetector(
                            onTap: () =>
                                selectedObjectCubit.selectObject(null),
                            child: const Material(
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: DeferredPointerHandler(
                            child: BlocBuilder(
                              bloc: sceneObjectsCubit,
                              builder: (
                                BuildContext context,
                                EditorSceneObjectsState state,
                              ) {
                                return GameObjectsRendering(state.objects);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: BlocBuilder<MagnetAreaCubit, MagnetAreaState>(
              builder: (
                BuildContext context,
                MagnetAreaState state,
              ) {
                return MagnetAreaView(
                  activeHorizontalPosition: state.activeHorizontalPosition,
                  activeVerticalPosition: state.activeVerticalPosition,
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
