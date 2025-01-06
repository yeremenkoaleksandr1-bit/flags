import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:drag_and_drop/drag_and_drop.dart';
import 'package:flags/domain/game_objects/base/process.game_object.dart';
import 'package:flags/domain/game_objects/flag/flag.dart';
import 'package:flags/features/games/presentation/puzzle/scene_components/emblem.dart';
import 'package:flags/features/games/presentation/puzzle/scene_components/factory.dart';
import 'package:flags/features/app/presentation/bloc/app_cubit.dart';
import 'package:flags/presentation/game/puzzle/puzzle_common.presenter.dart';
import 'package:flags/uikit/game_widgets/flag/flag.dart';
import 'package:flags/uikit/game_widgets/game_widgets.dart';
import 'package:flags/uikit/game_widgets/objects/game_objects_rendering.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flags/uikit/utils/render_box_exposed.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';


class GameFlagArea extends StatefulWidget {
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

  final IPuzzleCommonModeCubit cubit;

  final GameFlag flag;
  final List<ProcessGameObject> objects;
  final RenderBoxExposer exposer;

  final DragTargetWillAccept<ProcessGameObject>? onWillAccept;

  final bool Function(
    BuildContext context,
    SDragTargetDetails<ProcessGameObject> details,
  )? onWillAcceptWithDetails;

  final SDragTargetAccept<ProcessGameObject>? onAccept;

  final bool Function(
    BuildContext context,
    SDragTargetDetails<ProcessGameObject> object,
  )? onAcceptWithDetails;

  final SDragTargetLeave<ProcessGameObject>? onLeave;

  final SDragTargetMove<ProcessGameObject>? onMove;

  @override
  State<GameFlagArea> createState() => _GameFlagAreaState();
}

class _GameFlagAreaState extends State<GameFlagArea> {
  final GlobalKey _stackKey = GlobalKey();

  Iterable<GameObjectWidget> buildObjects(
    Iterable<ProcessGameObject> value,
  ) {
    return value.map(
      (e) {
        return PuzzleSceneItemsFactory.build(
          e,
          onEmblem: (o) => EmblemSceneObject(o, widget.cubit),
          onDefault: GameObjectWidget.new,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const Pad(horizontal: 8),
      child: Material(
        color: ThemePalette.black.withOpacity(0.7),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            RenderBoxExposed(
              exposer: widget.exposer,
              child: RepaintBoundary(
                child: FittedBox(
                  fit: BoxFit.fill,
                  alignment: Alignment.topLeft,
                  child: ClipRRect(
                    child: SizedBox.fromSize(
                      size: widget.flag.size.toSize(),
                      child: GameObjectsRendering(
                        [...buildObjects(widget.objects)],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            buildDragTargetArea(),
          ],
        ),
      ),
    );
  }

  Positioned buildDragTargetArea() {
    return Positioned.fill(
      child: Builder(
        builder: (BuildContext context) {
          return SDragTargetArea<ProcessGameObject>(
            onLeave: widget.onLeave,
            onAcceptWithDetails: (details) {
              return widget.onAcceptWithDetails?.call(context, details) ??
                  false;
            },
            onMove: widget.onMove,
            onWillAcceptWithDetails: (details) {
              return widget.onWillAcceptWithDetails?.call(context, details) ??
                  true;
            },
            builder: (
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
