import 'package:flags/domain/game_objects/base/game_object.dart';
import 'package:flags/logger.dart';
import 'package:flags/uikit/components/listenable_builder/listenable_builder.dart';
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
  GameObject get gameObject => widget.gameObject;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: CustomPaint(
        size: gameObject.size.toSize(),
        painter: GameObjectPainter(gameObject),
      ),
    );
  }
}

class GameObjectPainter extends CustomPainter {
  final GameObject gameObject;

  const GameObjectPainter(
    this.gameObject,
  );

  @override
  void paint(Canvas canvas, Size size) {
    gameObject.draw(canvas, size);
  }

  @override
  bool shouldRepaint(covariant GameObjectPainter oldDelegate) {
    return gameObject != oldDelegate.gameObject;
  }
}
