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

  @override
  Widget build(BuildContext context) {
    final child = buildWidget(context);

    return FastBuilder(
      () {
        final position = positionRx.value;
        final size = sizeRx.value;
        final rotation = rotationRx.value;

        final scale = scaleRx.value;

        final transform = MatrixUtils.transformRect(
          Matrix4.identity()
            ..translate(size.x / 2, size.y / 2)
            ..rotateZ(rotation)
            ..translate(-size.x / 2, -size.y / 2),
          size.toRect(),
        );

        final offset = (transform.toVector2() - size) / 2;

        return Positioned(
          left: position.x - offset.x,
          top: position.y - offset.y,
          width: transform.width,
          height: transform.height,
          child: child,
        );
      },
    );
  }
}
