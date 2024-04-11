import 'package:flags/core/elements/paint.dart';
import 'package:flags/core/path_drawing/path_drawing.dart';
import 'package:flags/domain/editor/shapes/shape.dart';
import 'package:flags/uikit/theme/theme.dart';

class SCrossShape extends SShape {
  SCrossShape({
    SPaint? paint,
  }) : super(
          path: parseSvgPathModel(
            "M39.3942 31.957L64.1716 56.7771L57.1081 63.8528L32.3307 39.0327L7.23513 64.1716L0.171631 57.0959L25.2672 31.957L0.600109 7.24726L7.66361 0.17157L32.3307 24.8813L56.6797 0.49032L63.7432 7.56602L39.3942 31.957Z",
          ),
          paint: paint ??
              SPaint(
                color: ThemePalette.red,
              ),
        );
}
