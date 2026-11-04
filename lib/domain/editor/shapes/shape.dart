import 'package:flags/domain/entities/path/path.dart';

abstract class SShape extends SPath {
  SShape({
    required super.paint,
    required SPath path,
  }) : super(
          rect: path.rect,
          points: path.points,
        );
}
