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
  late final GameObject _object = widget.gameObject.copyWith(
    position: Vector2.zero(),
  );

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: CustomPaint(
        size: _object.size.toSize(),
        painter: _Painter(_object),
      ),
    );
  }
}

class _Painter extends CustomPainter {
  final GameObject gameObject;

  _Painter(this.gameObject);

  @override
  void paint(Canvas canvas, Size size) {
    gameObject.draw(canvas, size);
  }

  @override
  bool shouldRepaint(covariant _Painter oldDelegate) {
    return gameObject != oldDelegate.gameObject;
  }
}
