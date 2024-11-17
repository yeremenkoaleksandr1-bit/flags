import 'package:flags/domain/converters/game_objects/drawn_object_converter.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/domain/game_objects/base/game_object.dart';
import 'package:flags/domain/game_objects/flag/flag.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../painters/drawable_painter.dart';

class FlagView extends StatelessWidget {
  const FlagView({super.key, required this.flag});

  final GameFlag flag;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: SizedBox(
        width: flag.size.x,
        height: flag.size.y,
        child: ClipRRect(
          child: CustomPaint(
            painter: DrawablePainter(
              flag,
            ),
          ),
        ),
      ),
    );
  }
}

class DrawablePainter extends CustomPainter {
  final GameFlag drawable;

  DrawablePainter(this.drawable);

  @override
  void paint(Canvas canvas, Size size) {
    for (final GameObject object in drawable.objects) {
      canvas.save();

      canvas.translate(
        object.position.x,
        object.position.y,
      );

      object.draw(
        canvas,
        object.size.toSize(),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant DrawablePainter oldDelegate) {
    return oldDelegate.drawable != drawable;
  }
}
