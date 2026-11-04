import 'package:flags/core/elements/paint.dart';
import 'package:flags/core/path_drawing/path_drawing.dart';
import 'package:flags/domain/editor/shapes/shape.dart';
import 'package:flags/uikit/theme/theme.dart';

class STriangleShape extends SShape {
  STriangleShape({
    SPaint? paint,
  }) : super(
          path: parseSvgPathModel(
            "m32 0 32 64H0L32 0Z",
          ),
          paint: paint ??
              SPaint(
                color: ThemePalette.red,
              ),
        );
}
