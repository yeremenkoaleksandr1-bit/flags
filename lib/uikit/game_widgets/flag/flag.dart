import 'package:flags/domain/game_objects/flag/flag.dart';
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
            painter: DrawablePainter(flag),
          ),
        ),
      ),
    );
  }
}
