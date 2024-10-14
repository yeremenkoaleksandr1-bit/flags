import 'package:flags/domain/game_objects/base/game_object.dart';
import 'package:flags/uikit/components/listenable_builder/listenable_builder.dart';
import 'package:flags/uikit/game_widgets/game_widgets.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/widgets.dart';

import 'game_objects_rendering.dart';

class GameObjectWidget<G extends GameObject> extends StatefulWidget {
  GameObjectWidget(this.gameObject, {GlobalKey? key})
      : super(
          key: key ?? GlobalKey(),
        );

  final G gameObject;

  @override
  State<GameObjectWidget<G>> createState() => GameObjectWidgetState();
}

class GameObjectWidgetState<G extends GameObject, T extends GameObjectWidget<G>>
    extends State<T> {
  late GameObjectsRenderingState renderingArea =
      GameObjectsRendering.of(context);

  late G gameObject = widget.gameObject;

  RenderBox get areaRenderBox => renderingArea.exposer.renderBox.value!;

  double get fitValue => areaRenderBox.size.width / gameObject.size.x;

  Widget buildWidget(BuildContext context) {
    return GameObjectPaint(
      gameObject: gameObject,
    );
  }

  Vector2 positionConverter(Vector2 position) => position;

  Vector2 sizeConverter(Vector2 size) => size;

  double rotationConverter(double rotation) => rotation;

  double scaleConverter(double scale) => scale;

  Rect transformRect({
    required Vector2 position,
    required Vector2 size,
    required double rotation,
    required double scale,
  }) =>
      position & size;

  Matrix4 transformationMatrix({
    required Vector2 position,
    required Vector2 size,
    required double rotation,
    required double scale,
  }) =>
      Matrix4.identity()..scale(scale);

  Alignment get rotateAlignment => Alignment.center;

  @override
  Widget build(BuildContext context) {
    final child = buildWidget(context);

    return FListenableBuilder(
      listenable: gameObject,
      builder: (
        BuildContext context,
        GameObject object,
        Widget? child,
      ) {
        final position = positionConverter(object.position);
        final scale = scaleConverter(object.scale);

        final size = sizeConverter(object.size);
        final rotation = rotationConverter(object.rotation);

        final rect = transformRect(
          position: position,
          size: size,
          rotation: rotation,
          scale: scale,
        );

        return Positioned.fromRect(
          rect: rect,
          child: Transform.rotate(
            alignment: rotateAlignment,
            angle: rotation,
            child: SizedBox.expand(
              child: RepaintBoundary(
                child: child,
              ),
            ),
          ),
        );
      },
      child: child,
    );
  }
}
