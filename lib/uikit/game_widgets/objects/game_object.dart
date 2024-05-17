import 'package:flags/domain/game_objects/base/game_object.dart';
import 'package:flags/uikit/game_widgets/game_widgets.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';

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

  ValueNotifier<Vector2> get positionRx => widget.gameObject.positionRx;

  ValueNotifier<Vector2> get sizeRx => widget.gameObject.sizeRx;

  ValueNotifier<double> get rotationRx => widget.gameObject.rotationRx;

  ValueNotifier<double> get scaleRx => widget.gameObject.scaleRx;

  Widget buildWidget(BuildContext context) {
    return GameObjectPaint(
      gameObject: widget.gameObject,
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

  @override
  Widget build(BuildContext context) {
    final child = buildWidget(context);

    return MultiValueListenableBuilder(
      valueListenables: [positionRx, scaleRx, sizeRx, rotationRx],
      builder: (BuildContext context, List<dynamic> values, Widget? child) {
        final position = positionConverter(values[0]);
        final scale = scaleConverter(values[1]);

        final size = sizeConverter(values[2]);
        final rotation = rotationConverter(values[3]);

        final rect = transformRect(
          position: position,
          size: size,
          rotation: rotation,
          scale: scale,
        );

        return Positioned.fromRect(
          rect: rect,
          child: Transform.rotate(
            alignment: Alignment.center,
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
