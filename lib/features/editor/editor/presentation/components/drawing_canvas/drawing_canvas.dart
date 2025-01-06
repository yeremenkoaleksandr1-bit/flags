import 'package:community_material_icon/community_material_icon.dart';
import 'package:flags/domain/entities/path/path.dart';
import 'package:flags/domain/game_objects/game_objects.dart';
import 'package:flags/features/editor/editor/presentation/bloc/flag_editor_cubit.dart';
import 'package:flags/features/editor/editor/presentation/cubits/boards/custom_paint/custom_paint_cubit.dart';
import 'package:flags/features/editor/editor/presentation/cubits/scene_objects/scene_objects_cubit.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/layout_components/gap/gap.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'actions.dart';

class DrawingCanvas extends StatelessWidget {
  const DrawingCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CustomPaintCubit(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<CustomPaintCubit>();

          void onConfirm() {
            final drawnObject = DrawnGameObject(
              name: UniqueKey().toString(),
              pathsHistory: cubit.state,
              size: Vector2(16, 16),
            );

            final sceneObjectsCubit = context.read<EditorSceneObjectsCubit>();

            final editorCubit = context.read<IFlagEditorCubit>();

            sceneObjectsCubit.addGameObject(drawnObject);
            editorCubit.toggleCustomPaintBoardOpen(false);
          }

          void onCancel() {
            final state = cubit.state;
            final editorCubit = context.read<IFlagEditorCubit>();

            editorCubit.toggleCustomPaintBoardOpen(false);
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Material(
                      clipBehavior: Clip.antiAlias,
                      color: Colors.white,
                      child: AspectRatio(
                        aspectRatio: 1,
                        child: BlocBuilder<CustomPaintCubit, CustomPaintState>(
                          builder: (context, state) {
                            return GestureDetector(
                              onPanStart: (details) {
                                final localPosition = details.localPosition;
                                cubit.add(localPosition);
                              },
                              onPanUpdate: (details) {
                                final localPosition = details.localPosition;
                                cubit.updateCurrent(localPosition);
                              },
                              onPanEnd: (_) {
                                cubit.endCurrent();
                              },
                              child: CustomPaint(
                                painter: _PathPainter(paths: state.paths),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Gap.v12,
                  Row(
                    children: [
                      FButton(
                        onPressed: cubit.undo,
                        color: ThemePalette.peach,
                        child: const Icon(
                          Icons.undo,
                          size: 32,
                        ),
                      ),
                      Gap.h4,
                      FButton(
                        onPressed: cubit.redo,
                        color: ThemePalette.peach,
                        child: const Icon(
                          Icons.redo,
                          size: 32,
                        ),
                      ),
                      const Spacer(),
                      BlocBuilder<CustomPaintCubit, CustomPaintState>(
                        buildWhen: (p, c) =>
                            p.currentPaint.blendMode !=
                            c.currentPaint.blendMode,
                        builder: (
                          BuildContext context,
                          CustomPaintState state,
                        ) {
                          return FButton(
                            onPressed: cubit.toggleDrawMode,
                            color: ThemePalette.peach,
                            child: Icon(
                              state.currentPaint.blendMode == BlendMode.srcOver
                                  ? CommunityMaterialIcons.brush
                                  : CommunityMaterialIcons.eraser,
                              size: 32,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Gap.v12,
                  const Expanded(
                    child: ActionsBoard(),
                  ),
                  Gap.v12,
                  Row(
                    spacing: 4,
                    children: [
                      Expanded(
                        flex: 2,
                        child: FRedButton(
                          onPressed: onCancel,
                          child: Center(child: FText("cancel")),
                        ),
                      ),
                   
                      Expanded(
                        flex: 3,
                        child: FGreenButton(
                          onPressed: onConfirm,
                          child: Center(child: FText("confirm")),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PathPainter extends CustomPainter {
  final List<SPath> paths;

  _PathPainter({required this.paths});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Rect.largest, Paint());
    for (final path in paths) {
      path.draw(canvas, size);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true; // Always repaint on state changes
  }
}
