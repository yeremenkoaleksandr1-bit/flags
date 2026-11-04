import 'package:flags/core/elements/paint.dart';
import 'package:flags/domain/entities/path/path.dart';
import 'package:flags/domain/entities/points/base/point_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'custom_paint_state.dart';

class CustomPaintCubit extends Cubit<CustomPaintState> {
  CustomPaintCubit() : super(CustomPaintState());

  static const double _minPointDistance = 1.5;

  final List<Offset> _lastPoints = [];
  final ValueNotifier<int> repaintListenable = ValueNotifier(0);

  bool get isEmpty =>
      state.paths.isEmpty || (state.paths.length == 1 && state.inDrag);

  bool get canUndo => !state.inDrag && state.paths.isNotEmpty;

  bool get canRedo => !state.inDrag && state.backupPaths.isNotEmpty;

  SPath get currentPath => state.paths.last;

  void _requestRepaint() {
    repaintListenable.value++;
  }

  void undo() {
    if (canUndo) {
      final last = state.paths.last;
      emit(
        state.copyWith(
          paths: List.from(state.paths)..removeLast(),
          backupPaths: List.from(state.backupPaths)..add(last),
        ),
      );
      _requestRepaint();
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
    _requestRepaint();
  }

  void changeWidth(double value) {
    emit(
      state.copyWith(
        currentPaint: state.currentPaint.copyWith(
          strokeWidth: value,
        ),
      ),
    );
    _requestRepaint();
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
    _requestRepaint();
  }

  void redo() {
    if (!canRedo) {
      return;
    }

    final last = state.backupPaths.last;
    emit(
      state.copyWith(
        paths: List.from(state.paths)..add(last),
        backupPaths: List.from(state.backupPaths)..removeLast(),
      ),
    );
    _requestRepaint();
  }

  void clear() {
    if (!state.inDrag) {
      emit(
        state.copyWith(
          paths: [],
          backupPaths: [],
        ),
      );
      _requestRepaint();
    }
  }

  void add(Offset startPoint) {
    emit(state.copyWith(backupPaths: []));

    if (!state.inDrag) {
      _lastPoints
        ..clear()
        ..add(startPoint);
      final newPath = _buildPathFromOffsets(_lastPoints, state.currentPaint);
      emit(
        state.copyWith(
          inDrag: true,
          paths: List.from(state.paths)..add(newPath),
        ),
      );
      _requestRepaint();
    }
  }

  void updateCurrent(Offset point) {
    if (state.inDrag) {
      final lastPoint = _lastPoints.last;
      final distance = (point - lastPoint).distance;
      if (distance >= _minPointDistance) {
        _lastPoints.add(point);

        final lastPath = _buildPathFromOffsets(
          _lastPoints,
          state.paths.last.paint,
        );

        emit(
          state.copyWith(
            paths: List.from(state.paths)..[state.paths.length - 1] = lastPath,
          ),
        );
        _requestRepaint();
      }
    }
  }

  void endCurrent() {
    if (_lastPoints.length <= 1 && state.inDrag) {
      emit(state.copyWith(paths: List.from(state.paths)..removeLast()));
      _requestRepaint();
    } else if (state.inDrag && state.paths.isNotEmpty) {
      final lastPath = state.paths.last;
      final finalizedPath = lastPath.copyWith(rect: lastPath.bounds);

      emit(
        state.copyWith(
          paths: List.from(state.paths)
            ..[state.paths.length - 1] = finalizedPath,
        ),
      );
      _requestRepaint();
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

  SPath _buildPathFromOffsets(List<Offset> offsets, SPaint paint) {
    final points = _buildSmoothPoints(offsets);
    final path = SPath(
      points: points,
      paint: paint,
      rect: Rect.zero,
    );

    return path.copyWith(rect: path.bounds);
  }

  List<SPoint> _buildSmoothPoints(List<Offset> offsets) {
    if (offsets.isEmpty) {
      return const [];
    }

    if (offsets.length == 1) {
      final point = offsets.first;
      return [
        SPoint.move(point.dx, point.dy),
      ];
    }

    if (offsets.length == 2) {
      final start = offsets.first;
      final end = offsets.last;
      return [
        SPoint.move(start.dx, start.dy),
        SPoint.line(end.dx, end.dy),
      ];
    }

    final points = <SPoint>[
      SPoint.move(offsets.first.dx, offsets.first.dy),
    ];

    var current = offsets.first;

    for (var i = 1; i < offsets.length - 1; i++) {
      final control = offsets[i];
      final end = _midpoint(control, offsets[i + 1]);

      points.add(_quadraticToCubic(current, control, end));
      current = end;
    }

    points.add(
      _quadraticToCubic(
        current,
        offsets[offsets.length - 2],
        offsets.last,
      ),
    );

    return points;
  }

  SPoint _quadraticToCubic(Offset start, Offset control, Offset end) {
    final control1 = Offset(
      start.dx + (2 / 3) * (control.dx - start.dx),
      start.dy + (2 / 3) * (control.dy - start.dy),
    );
    final control2 = Offset(
      end.dx + (2 / 3) * (control.dx - end.dx),
      end.dy + (2 / 3) * (control.dy - end.dy),
    );

    return SPoint.cubit(
      control1.dx,
      control1.dy,
      control2.dx,
      control2.dy,
      end.dx,
      end.dy,
    );
  }

  Offset _midpoint(Offset a, Offset b) {
    return Offset(
      (a.dx + b.dx) / 2,
      (a.dy + b.dy) / 2,
    );
  }

  @override
  Future<void> close() {
    repaintListenable.dispose();
    return super.close();
  }
}
