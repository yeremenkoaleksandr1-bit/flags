import 'package:flags/core/elements/paint.dart';
import 'package:flags/core/path_drawing/path_drawing.dart';
import 'package:flags/domain/editor/shapes/shape.dart';
import 'package:flags/uikit/theme/theme.dart';

class SCircleShape extends SShape {
  SCircleShape({
    SPaint? paint,
  }) : super(
          path: parseSvgPathModel(
            "M64 32c0 17.673-14.327 32-32 32C14.327 64 0 49.673 0 32 0 14.327 14.327 0 32 0c17.673 0 32 14.327 32 32Z",
          ),
          paint: paint ??
              SPaint(
                color: ThemePalette.red,
              ),
        );
}
