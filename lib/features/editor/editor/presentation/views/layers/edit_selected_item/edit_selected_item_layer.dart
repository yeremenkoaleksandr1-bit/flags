import 'package:flags/domain/game_objects/base/game_object.dart';
import 'package:flags/features/editor/editor/presentation/cubits/area/area_cubit.dart';
import 'package:flags/features/editor/editor/presentation/cubits/selected_object/selected_object_cubit.dart';
import 'package:flags/features/editor/editor/presentation/object_handles/editor_draggable.dart';
import 'package:flags/uikit/components/listenable_builder/listenable_builder.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memoize/memoize.dart';

import 'edit_selected_item_actions.dart';

class EditorEditSelectedItemLayer extends StatefulWidget {
  const EditorEditSelectedItemLayer({super.key});

  @override
  State<EditorEditSelectedItemLayer> createState() =>
      _EditorEditSelectedItemLayerState();
}

class _EditorEditSelectedItemLayerState
    extends State<EditorEditSelectedItemLayer> {
  late final bloc = context.read<EditorSelectedObjectCubit>();
  late final areaCubit = context.read<EditorAreaCubit>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditorAreaCubit, EditorAreaState>(
      bloc: areaCubit,
      builder: (BuildContext context, area) {
        final sizeFunc = memo2(
          (Vector2 v, double fraction) => Size(
            v.x * fraction,
            v.y * fraction,
          ),
        );

        final offsetFunc = memo2(
          (Vector2 v, double fraction) => Offset(
            area.rect.left + v.x * fraction,
            area.rect.top + v.y * fraction,
          ),
        );

        return BlocBuilder<EditorSelectedObjectCubit,
            EditorSelectedObjectState>(
          bloc: bloc,
          builder: (
            BuildContext context,
            EditorSelectedObjectState state,
          ) {
            final object = state.object;

            final fraction = area.rect.size.width / 64;

            if (object != null &&
                object.key != null &&
                (object.key! as GlobalKey).currentState != null) {
              final link = (object.key! as GlobalKey).currentState!
                  as EditorDraggableWidgetState;

              return FListenableBuilder(
                listenable: link.gameObject,
                builder: (
                  BuildContext context,
                  GameObject value,
                  Widget? child,
                ) {
                  final size = sizeFunc(value.size, fraction);
                  final offset = offsetFunc(value.position, fraction);

                  return SizedBox(
                    width: size.width + 32,
                    height: size.height + 32,
                    child: Transform.translate(
                      offset: offset,
                      child: Transform.rotate(
                        alignment: Alignment.topLeft,
                        angle: value.rotation,
                        child: child,
                      ),
                    ),
                  );
                },
                child: Transform.translate(
                  offset: const Offset(-16, -16),
                  child: EditSelectedItemActions(
                    fraction: fraction,
                    link: link,
                    areaRect: area.rect,
                  ),
                ),
              );
            }

            return const SizedBox();
          },
        );
      },
    );
  }
}
