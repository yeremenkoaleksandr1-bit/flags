import 'package:flags/domain/game_objects/base/game_object.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

class GameObjectPaint extends StatefulWidget {
  const GameObjectPaint({
    super.key,
    required this.gameObject,
  });

  final GameObject gameObject;

  @override
  State<GameObjectPaint> createState() => _GameObjectPaintState();
}

class _GameObjectPaintState extends State<GameObjectPaint> {
  @override
  Widget build(BuildContext context) {
    final object = widget.gameObject.copyWith(
      position: Vector2.zero(),
    );

    return FittedBox(
      child: CustomPaint(
        size: object.size.toSize(),
        painter: GameObjectPainter(object),
      ),
    );
  }
}

class GameObjectPainter extends CustomPainter {
  final GameObject gameObject;

  const GameObjectPainter(this.gameObject);

  @override
  void paint(Canvas canvas, Size size) {
    gameObject.draw(canvas, size);
  }

  @override
  bool shouldRepaint(covariant GameObjectPainter oldDelegate) {
    return gameObject != oldDelegate.gameObject;
  }
}
