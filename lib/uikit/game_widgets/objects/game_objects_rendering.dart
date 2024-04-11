import 'package:defer_pointer/defer_pointer.dart';
import 'package:flags/uikit/game_widgets/objects/game_object.dart';
import 'package:flags/uikit/utils/render_box_exposed.dart';
import 'package:flutter/material.dart';

class GameObjectsRendering extends StatefulWidget {
  const GameObjectsRendering(
    this.objects, {
    super.key,
  });

  static GameObjectsRenderingState of<G>(BuildContext context) {
    final state = context.findAncestorStateOfType<GameObjectsRenderingState>();

    assert(
      state != null,
      'Context does not include a GameObjectsRenderingState.',
    );

    return state!;
  }

  final List<GameObjectWidget> objects;

  @override
  State<GameObjectsRendering> createState() => GameObjectsRenderingState();
}

class GameObjectsRenderingState extends State<GameObjectsRendering> {
  final RenderBoxExposer exposer = RenderBoxExposer();

  final DeferredPointerHandlerLink deferredPointerHandlerLink =
      DeferredPointerHandlerLink();

  @override
  Widget build(BuildContext context) {
    return RenderBoxExposed(
      exposer: exposer,
      child: Stack(
        fit: StackFit.passthrough,
        clipBehavior: Clip.antiAlias,
        children: widget.objects,
      ),
    );
  }
}
