import 'package:flags/core/elements/paint.dart';
import 'package:flags/core/path_drawing/path_drawing.dart';
import 'package:flags/domain/editor/shapes/shape.dart';
import 'package:flags/uikit/theme/theme.dart';

class SStarShape extends SShape {
  SStarShape({
    SPaint? paint,
  }) : super(
          path: parseSvgPathModel(
            "m33.647 0 7.943 24.446h25.704L46.499 39.554 54.442 64 33.647 48.892 12.852 64l7.943-24.446L0 24.446h25.704L33.647 0Z",
          ),
          paint: paint ??
              SPaint(
                color: ThemePalette.red,
              ),
        );
}
