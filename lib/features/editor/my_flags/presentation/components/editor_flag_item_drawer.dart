import 'dart:math';

import 'package:flags/domain/editor/editor_flag.dart';
import 'package:flutter/cupertino.dart';

class EditorFlagItemDrawer extends StatelessWidget {
  final EditorFlagData flag;

  const EditorFlagItemDrawer({
    super.key,
    required this.flag,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        return SizedBox.fromSize(
          size: flag.backgroundStyle.rect.size,
          child: CustomPaint(
            painter: _Painter(flag, constraints.biggest),
          ),
        );
      },
    );
  }
}

class _Painter extends CustomPainter {
  final EditorFlagData flag;
  final Size originalSize;

  _Painter(this.flag, this.originalSize);

  late final fs = flag.backgroundStyle.rect.size;

  late final mps = max(fs.width, fs.height);
  late final mops = max(originalSize.width, originalSize.height);

  @override
  void paint(Canvas canvas, Size size) {
    flag.backgroundStyle.draw(canvas, size);

    for (final object in flag.objects) {
      canvas.saveLayer(Offset.zero & size, Paint());
      canvas.translate(
        object.position.x,
        object.position.y,
      );

      canvas.rotate(object.rotation);

      object.draw(canvas, size);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _Painter oldDelegate) =>
      flag != oldDelegate.flag;
}
