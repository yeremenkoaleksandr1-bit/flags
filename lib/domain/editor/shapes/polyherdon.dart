import 'package:flags/core/elements/paint.dart';
import 'package:flags/core/path_drawing/path_drawing.dart';
import 'package:flags/domain/editor/shapes/shape.dart';
import 'package:flags/uikit/theme/theme.dart';

class SPolyhedronShape extends SShape {
  SPolyhedronShape({
    SPaint? paint,
  }) : super(
          path: parseSvgPathModel(
            "m30.434 0 30.434 22.111L49.243 57.89H11.625L0 22.11 30.434 0Z",
          ),
          paint: paint ??
              SPaint(
                color: ThemePalette.red,
              ),
        );
}
