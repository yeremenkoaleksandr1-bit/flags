part of 'custom_paint_cubit.dart';

final class CustomPaintState {
  final List<SPath> paths;
  final List<SPath> backupPaths;
  final SPaint currentPaint;
  final bool inDrag;

  CustomPaintState({
    this.paths = const <SPath>[],
    this.backupPaths = const <SPath>[],
    SPaint? currentPaint,
    this.inDrag = false,
  }) : currentPaint = currentPaint ??
            SPaint(
              color: Colors.black,
              strokeWidth: 4,
              strokeCap: StrokeCap.round,
              strokeJoin: StrokeJoin.miter,
              style: PaintingStyle.stroke,
            );

  SPath get currentPath => paths.last;

  CustomPaintState copyWith({
    List<SPath>? paths,
    List<SPath>? backupPaths,
    SPaint? currentPaint,
    bool? inDrag,
  }) {
    return CustomPaintState(
      paths: paths ?? this.paths,
      backupPaths: backupPaths ?? this.backupPaths,
      currentPaint: currentPaint ?? this.currentPaint,
      inDrag: inDrag ?? this.inDrag,
    );
  }
}
