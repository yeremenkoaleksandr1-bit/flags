import 'package:community_material_icon/community_material_icon.dart';
import 'package:flags/domain/entities/path/path.dart';
import 'package:flags/domain/entities/points/points.dart';
import 'package:flags/domain/game_objects/game_objects.dart';
import 'package:flags/features/editor/editor/presentation/bloc/flag_editor_cubit.dart';
import 'package:flags/features/editor/editor/presentation/components/drawing_canvas/actions.dart';
import 'package:flags/features/editor/editor/presentation/cubits/boards/custom_paint/custom_paint_cubit.dart';
import 'package:flags/features/editor/editor/presentation/cubits/scene_objects/scene_objects_cubit.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/layout_components/gap/gap.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DrawingCanvas extends StatelessWidget {
  const DrawingCanvas({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CustomPaintCubit(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<CustomPaintCubit>();
          var canvasSize = DrawnGameObject.viewportSize;

          void onConfirm() {
            final drawnObject = DrawnGameObject(
              name: UniqueKey().toString(),
              pathsHistory: _normalizeState(
                cubit.state,
                canvasSize,
              ),
              size: Vector2(16, 16),
            );

            final sceneObjectsCubit = context.read<EditorSceneObjectsCubit>();

            final editorCubit = context.read<IFlagEditorCubit>();

            sceneObjectsCubit.addGameObject(drawnObject);
            editorCubit.toggleCustomPaintBoardOpen(false);
          }

          void onCancel() {
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
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          canvasSize = constraints.biggest.shortestSide;

                          return AspectRatio(
                            aspectRatio: 1,
                            child: GestureDetector(
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
                              child: RepaintBoundary(
                                child: CustomPaint(
                                  painter: _PathPainter(cubit),
                                  isComplex: true,
                                  willChange: true,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  Gap.v12,
                  BlocBuilder<CustomPaintCubit, CustomPaintState>(
                    buildWhen: (p, c) =>
                        p.paths.length != c.paths.length ||
                        p.backupPaths.length != c.backupPaths.length ||
                        p.inDrag != c.inDrag ||
                        p.currentPaint.blendMode != c.currentPaint.blendMode,
                    builder: (
                      BuildContext context,
                      CustomPaintState state,
                    ) {
                      return Row(
                        children: [
                          FButton(
                            onPressed: cubit.canUndo ? cubit.undo : () {},
                            color: ThemePalette.peach,
                            child: const Icon(
                              Icons.undo,
                              size: 32,
                            ),
                          ),
                          Gap.h4,
                          FButton(
                            onPressed: cubit.canRedo ? cubit.redo : () {},
                            color: ThemePalette.peach,
                            child: const Icon(
                              Icons.redo,
                              size: 32,
                            ),
                          ),
                          Gap.h4,
                          FButton(
                            onPressed: cubit.isEmpty ? () {} : cubit.clear,
                            color: ThemePalette.peach,
                            child: const Icon(
                              Icons.delete_outline,
                              size: 32,
                            ),
                          ),
                          const Spacer(),
                          FButton(
                            onPressed: cubit.toggleDrawMode,
                            color: ThemePalette.peach,
                            child: Icon(
                              state.currentPaint.blendMode == BlendMode.srcOver
                                  ? CommunityMaterialIcons.brush
                                  : CommunityMaterialIcons.eraser,
                              size: 32,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  Gap.v12,
                  const Expanded(
                    child: ActionsBoard(),
                  ),
                  Gap.v12,
                  BlocBuilder<CustomPaintCubit, CustomPaintState>(
                    buildWhen: (p, c) =>
                        p.paths.length != c.paths.length || p.inDrag != c.inDrag,
                    builder: (context, state) {
                      final canConfirm = !cubit.isEmpty && !state.inDrag;

                      return Row(
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
                              onPressed: canConfirm ? onConfirm : () {},
                              child: Center(child: FText("confirm")),
                            ),
                          ),
                        ],
                      );
                    },
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

CustomPaintState _normalizeState(
  CustomPaintState state,
  double canvasSize,
) {
  final scale = DrawnGameObject.viewportSize / canvasSize;

  return state.copyWith(
    paths: state.paths.map((path) => _normalizePath(path, scale)).toList(),
    backupPaths: state.backupPaths
        .map((path) => _normalizePath(path, scale))
        .toList(),
    currentPaint: state.currentPaint.copyWith(
      strokeWidth: state.currentPaint.strokeWidth * scale,
    ),
  );
}

SPath _normalizePath(SPath path, double scale) {
  final normalized = SPath(
    paint: path.paint.copyWith(
      strokeWidth: path.paint.strokeWidth * scale,
    ),
    rect: Rect.zero,
    points: path.points.map((point) => _normalizePoint(point, scale)).toList(),
  );

  return normalized.copyWith(rect: normalized.bounds);
}

SPoint _normalizePoint(SPoint point, double scale) {
  return switch (point) {
    SMovePoint() => SMovePoint(point.x * scale, point.y * scale),
    SLinePoint() => SLinePoint(point.x * scale, point.y * scale),
    SCubitPoint() => SCubitPoint(
        point.x1 * scale,
        point.y1 * scale,
        point.x2 * scale,
        point.y2 * scale,
        point.x3 * scale,
        point.y3 * scale,
      ),
    SClosePoint() => SClosePoint(),
    _ => point.copyWith(scale: scale),
  };
}

class _PathPainter extends CustomPainter {
  final CustomPaintCubit cubit;

  _PathPainter(this.cubit) : super(repaint: cubit.repaintListenable);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint());
    for (final path in cubit.state.paths) {
      path.draw(canvas, size);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PathPainter oldDelegate) =>
      oldDelegate.cubit != cubit;
}
