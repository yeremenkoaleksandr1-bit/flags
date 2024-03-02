import 'package:armar/armar.dart';
import 'package:flags/domain/game_objects/base/game_object.dart';
import 'package:flags/uikit/game_widgets/game_widgets.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/widgets.dart';

import 'game_objects_rendering.dart';

class GameObjectWidget<G extends GameObject> extends StatefulWidget {
  const GameObjectWidget(this.gameObject, {super.key});

  final G gameObject;

  @override
  State<GameObjectWidget<G>> createState() => GameObjectWidgetState();
}

class GameObjectWidgetState<G extends GameObject, T extends GameObjectWidget<G>>
    extends State<T> {
  late GameObjectsRenderingState renderingArea =
      GameObjectsRendering.of(context);

  G get gameObject => widget.gameObject;

  RenderBox get areaRenderBox => renderingArea.exposer.renderBox.value!;

  double get fitValue => areaRenderBox.size.width / widget.gameObject.size.x;

  late final RxValue<Vector2> positionRx = RxValue(widget.gameObject.position);
  late final RxValue<Vector2> sizeRx = RxValue(widget.gameObject.size);
  late final RxValue<double> rotationRx = RxValue(widget.gameObject.rotation);
  late final RxValue<double> scaleRx = RxValue(widget.gameObject.scale);

  Widget buildWidget(BuildContext context) {
    return GameObjectPaint(
      gameObject: widget.gameObject,
    );
  }

  Vector2 positionConverter(Vector2 position) => position;

  Vector2 sizeConverter(Vector2 size) => size;

  double rotationConverter(double rotation) => rotation;

  double scaleConverter(double scale) => scale;

  @override
  Widget build(BuildContext context) {
    final child = buildWidget(context);

    return FastBuilder(
      () {
        final position = positionConverter(positionRx.value);
        final size = sizeConverter(sizeRx.value);
        final rotation = rotationConverter(rotationRx.value);

        final scale = scaleConverter(scaleRx.value);

        return Positioned(
          left: position.x,
          top: position.y,
          width: size.x,
          height: size.y,
          child: Transform.scale(
            scale: scale,
            child: Transform.rotate(
              angle: rotation,
              child: Center(
                child: RepaintBoundary(
                  child: SizedBox(
                    width: size.x,
                    height: size.y,
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
