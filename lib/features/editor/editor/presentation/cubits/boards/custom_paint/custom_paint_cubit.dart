import 'package:bloc/bloc.dart';
import 'package:flags/core/elements/paint.dart';
import 'package:flags/domain/entities/path/path.dart';
import 'package:flags/domain/entities/points/base/point_entity.dart';
import 'package:flutter/material.dart';

part 'custom_paint_state.dart';

class CustomPaintCubit extends Cubit<CustomPaintState> {
  CustomPaintCubit() : super(CustomPaintState());

  final List<Offset> _lastPoints = [];

  bool get isEmpty =>
      state.paths.isEmpty || (state.paths.length == 1 && state.inDrag);

  bool get canRedo =>
      state.backupPaths.isEmpty ||
      (state.backupPaths.length == 1 && state.inDrag);

  SPath get currentPath => state.paths.last;

  void undo() {
    if (!state.inDrag && state.paths.isNotEmpty) {
      final last = state.paths.last;
      emit(
        state.copyWith(
          paths: List.from(state.paths)..removeLast(),
          backupPaths: List.from(state.backupPaths)..add(last),
        ),
      );
    }
  }

  void changeColor(Color value) {
    emit(
      state.copyWith(
        currentPaint: state.currentPaint.copyWith(
          color: value,
        ),
      ),
    );
  }

  void changeWidth(double value) {
    emit(
      state.copyWith(
        currentPaint: state.currentPaint.copyWith(
          strokeWidth: value,
        ),
      ),
    );
  }

  void toggleDrawMode() {
    emit(
      state.copyWith(
        currentPaint: state.currentPaint.copyWith(
          blendMode: state.currentPaint.blendMode == BlendMode.srcOver
              ? BlendMode.clear
              : BlendMode.srcOver,
        ),
      ),
    );
  }

  void redo() {
    if (state.backupPaths.isEmpty) {
      return;
    }

    final last = state.backupPaths.last;
    emit(
      state.copyWith(
        paths: List.from(state.paths)..add(last),
        backupPaths: List.from(state.backupPaths)..removeLast(),
      ),
    );
  }

  void clear() {
    if (!state.inDrag) {
      emit(
        state.copyWith(
          paths: [],
          backupPaths: [],
        ),
      );
    }
  }

  void add(Offset startPoint) {
    emit(state.copyWith(backupPaths: []));

    if (!state.inDrag) {
      _lastPoints.add(startPoint);
      final newPath = SPath(
        points: [SPoint.move(startPoint.dx, startPoint.dy)],
        paint: state.currentPaint,
        rect: Rect.zero,
      );
      emit(
        state.copyWith(
          inDrag: true,
          paths: List.from(state.paths)..add(newPath),
        ),
      );
    }
  }

  void updateCurrent(Offset point) {
    if (state.inDrag) {
      final lastPoint = _lastPoints.last;
      if ((lastPoint.dx - point.dx).abs() > 0.25 &&
          (lastPoint.dy - point.dy).abs() > 0.25) {
        _lastPoints.add(point);

        final lastPath = state.paths.last.copyWith(
          points: List.from(state.paths.last.points)
            ..add(SPoint.line(point.dx, point.dy)),
        );

        emit(
          state.copyWith(
            paths: List.from(state.paths)..[state.paths.length - 1] = lastPath,
          ),
        );
      }
    }
  }

  void endCurrent() {
    if (_lastPoints.length <= 1 && state.inDrag) {
      emit(state.copyWith(paths: List.from(state.paths)..removeLast()));
    }
    _lastPoints.clear();
    emit(state.copyWith(inDrag: false));
  }

  void draw(Canvas canvas, Size size, [void Function()? drawAfterSave]) {
    canvas.saveLayer(Offset.zero & size, Paint());

    drawAfterSave?.call();

    for (final path in state.paths) {
      path.draw(canvas, size);
    }

    canvas.restore();
  }
}
