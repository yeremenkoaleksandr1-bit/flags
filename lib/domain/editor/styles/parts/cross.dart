import 'package:flags/core/utils/utils.dart';
import 'package:flags/domain/entities/path/path.dart';
import 'package:flags/domain/entities/points/base/point_entity.dart';

class CrossPart extends SPath {
  CrossPart({
    required super.paint,
    required super.rect,
    required double width,
    required double height,
    double deviationVertical = 1,
    double deviationHorizontal = 1,
  }) : super(
          points: [
            SPoint.move(0, 0),
            SPoint.move(
              rect.centerX - width / 2,
              rect.centerY * deviationVertical,
            ),
            SPoint.line(
              rect.centerX + width / 2,
              rect.centerY * deviationVertical,
            ),
            SPoint.move(
              rect.centerX * deviationHorizontal,
              rect.centerY - height / 2,
            ),
            SPoint.line(
              rect.centerX * deviationHorizontal,
              rect.centerY + height / 2,
            ),
            SPoint.move(rect.width, rect.height),
          ],
        );
}
