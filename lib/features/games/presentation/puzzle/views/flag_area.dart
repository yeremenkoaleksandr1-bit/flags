import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:drag_and_drop/drag_and_drop.dart';
import 'package:flags/domain/game_objects/base/process.game_object.dart';
import 'package:flags/domain/game_objects/flag/flag.dart';
import 'package:flags/features/app/presentation/bloc/app_cubit.dart';
import 'package:flags/features/games/presentation/puzzle/scene_components/emblem.dart';
import 'package:flags/features/games/presentation/puzzle/scene_components/factory.dart';
import 'package:flags/presentation/game/puzzle/puzzle_common.presenter.dart';
import 'package:flags/uikit/game_widgets/game_widgets.dart';
import 'package:flags/uikit/game_widgets/objects/game_objects_rendering.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flags/uikit/utils/render_box_exposed.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameFlagArea extends StatelessWidget {
  const GameFlagArea({
    super.key,
    required this.objects,
    required this.flag,
    required this.exposer,
    this.onWillAccept,
    this.onWillAcceptWithDetails,
    this.onAccept,
    this.onAcceptWithDetails,
    this.onLeave,
    this.onMove,
    required this.cubit,
  });

  final PuzzleCommonModeCubit cubit;

  final GameFlag flag;
  final List<ProcessGameObject> objects;
  final RenderBoxExposer exposer;

  final DragTargetWillAccept<ProcessGameObject>? onWillAccept;

  final bool Function(
    BuildContext context,
    SDragTargetDetails<ProcessGameObject> details,
  )?
  onWillAcceptWithDetails;

  final SDragTargetAccept<ProcessGameObject>? onAccept;

  final bool Function(
    BuildContext context,
    SDragTargetDetails<ProcessGameObject> object,
  )?
  onAcceptWithDetails;

  final SDragTargetLeave<ProcessGameObject>? onLeave;

  final SDragTargetMove<ProcessGameObject>? onMove;

  @override
  Widget build(BuildContext context) {
    final isDebugMode = context.select<IAppCubit, bool>(
      (appCubit) => appCubit.preferences.isDebugMode,
    );
    final flagSize = flag.size.toSize();
    final flagAspectRatio = flag.size.x / flag.size.y;
    final placedObjects = _buildObjects(objects).toList(growable: false);
    final debugObjects = isDebugMode
        ? _buildObjects(flag.objects).toList(growable: false)
        : null;

    return Padding(
      padding: const Pad(horizontal: 8),
      child: Material(
        color: Colors.transparent,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final surfaceSize = _resolveSurfaceSize(
              constraints.biggest,
              flagAspectRatio,
            );

            return Center(
              child: SizedBox.fromSize(
                size: surfaceSize,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: ThemePalette.black.withValues(alpha: 0.7),
                      ),
                    ),
                    RenderBoxExposed(
                      exposer: exposer,
                      child: RepaintBoundary(
                        child: _buildFlagLayer(
                          flagSize: flagSize,
                          objects: placedObjects,
                        ),
                      ),
                    ),
                    if (debugObjects != null)
                      IgnorePointer(
                        child: Opacity(
                          opacity: 0.2,
                          child: _buildFlagLayer(
                            flagSize: flagSize,
                            objects: debugObjects,
                          ),
                        ),
                      ),
                    _buildDragTargetArea(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Iterable<GameObjectWidget> _buildObjects(
    Iterable<ProcessGameObject> objects,
  ) {
    return objects.map(
      (object) => PuzzleSceneItemsFactory.build(
        object,
        onEmblem: (emblem) => EmblemSceneObject(emblem, cubit),
        onDefault: GameObjectWidget.new,
      ),
    );
  }

  Widget _buildFlagLayer({
    required Size flagSize,
    required List<GameObjectWidget> objects,
  }) {
    return ClipRRect(
      child: SizedBox.expand(
        child: FittedBox(
          fit: BoxFit.fill,
          child: SizedBox.fromSize(
            size: flagSize,
            child: GameObjectsRendering(objects),
          ),
        ),
      ),
    );
  }

  Size _resolveSurfaceSize(Size availableSize, double aspectRatio) {
    if (availableSize.isEmpty) {
      return Size.zero;
    }

    final availableAspectRatio = availableSize.width / availableSize.height;

    if (availableAspectRatio > aspectRatio) {
      return Size(availableSize.height * aspectRatio, availableSize.height);
    }

    return Size(availableSize.width, availableSize.width / aspectRatio);
  }

  Positioned _buildDragTargetArea() {
    return Positioned.fill(
      child: Builder(
        builder: (BuildContext context) {
          return SDragTargetArea<ProcessGameObject>(
            onLeave: onLeave,
            onAcceptWithDetails: (details) {
              return onAcceptWithDetails?.call(context, details) ?? false;
            },
            onMove: onMove,
            onWillAcceptWithDetails: (details) {
              return onWillAcceptWithDetails?.call(context, details) ?? true;
            },
            builder:
                (
                  BuildContext context,
                  List<ProcessGameObject?> candidateData,
                  List<dynamic> rejectedData,
                ) {
                  return DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: candidateData.isNotEmpty
                            ? ThemePalette.black
                            : ThemePalette.transparent,
                        width: 2,
                        strokeAlign: BorderSide.strokeAlignOutside,
                      ),
                    ),
                  );
                },
          );
        },
      ),
    );
  }
}
