import 'package:flags/core/elements/paint.dart';
import 'package:flags/core/path_drawing/path_drawing.dart';
import 'package:flags/domain/editor/shapes/shape.dart';
import 'package:flags/uikit/theme/theme.dart';

class SSquareShape extends SShape {
  SSquareShape({
    SPaint? paint,
  }) : super(
          path: parseSvgPathModel(
            "M0 0h64v64H0V0Z",
          ),
          paint: paint ??
              SPaint(
                color: ThemePalette.red,
              ),
        );
}
