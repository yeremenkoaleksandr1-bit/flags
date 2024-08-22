import 'package:flags/screens/editor/editor/presentation/cubits/area/area_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/selected_object/selected_object_cubit.dart';
import 'package:flags/screens/editor/editor/presentation/object_handles/editor_draggable.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        return AbsorbPointer(
          child:
              BlocBuilder<EditorSelectedObjectCubit, EditorSelectedObjectState>(
            bloc: bloc,
            builder: (
              BuildContext context,
              EditorSelectedObjectState state,
            ) {
              final object = state.object;

              final fraction = area.rect.size.width / 64;

              if (object != null) {
                final link = (object.key! as GlobalKey).currentState!
                    as EditorDraggableWidgetState;

                return ValueListenableBuilder(
                  valueListenable: link.sizeRx,
                  builder: (
                    BuildContext context,
                    Vector2 value,
                    Widget? child,
                  ) {
                    final size = Size(
                      value.x * fraction,
                      value.y * fraction,
                    );
                    return SizedBox(
                      width: size.width + 16 * 2,
                      height: size.height + 16 * 2,
                      child: child,
                    );
                  },
                  child: ValueListenableBuilder(
                    valueListenable: link.positionRx,
                    builder: (
                      BuildContext context,
                      Vector2 value,
                      Widget? child,
                    ) {
                      final offset = Offset(
                        area.rect.left + value.x * fraction,
                        area.rect.top + value.y * fraction,
                      );

                      return Transform.translate(
                        offset: offset,
                        child: child,
                      );
                    },
                    child: ValueListenableBuilder(
                      valueListenable: link.rotationRx,
                      builder: (
                        BuildContext context,
                        double value,
                        Widget? child,
                      ) {
                        return Transform.rotate(
                          alignment: Alignment.topLeft,
                          angle: value,
                          child: child,
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
                    ),
                  ),
                );
              }

              return const SizedBox();
            },
          ),
        );
      },
    );
  }
}
