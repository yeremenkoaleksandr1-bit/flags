// ignore_for_file: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
import 'package:flags/core/elements/paint.dart';
import 'package:flags/domain/entities/path/path.dart';
import 'package:flags/domain/entities/points/base/point_entity.dart';
import 'package:flutter/material.dart' hide Image;

class PathHistory {
  final Size originalSize;

  final ValueNotifier<List<SPath>> _paths;
  final ValueNotifier<List<SPath>> _backupPaths;
  final ValueNotifier<SPaint> currentPaint;
  bool _inDrag;

  bool get isEmpty =>
      _paths.value.isEmpty || (_paths.value.length == 1 && _inDrag);

  bool get canRedo =>
      _backupPaths.value.isEmpty || (_backupPaths.value.length == 1 && _inDrag);

  SPath get currentPath => _paths.value.last;

  ValueNotifier<List<SPath>> get paths => _paths;

  final List<Offset> _lastPoints = [];

  PathHistory({
    this.originalSize = Size.zero,
    List<SPath>? paths,
  })  : _paths = ValueNotifier(paths ?? <SPath>[]),
        _backupPaths = ValueNotifier(<SPath>[]),
        _inDrag = false,
        currentPaint = ValueNotifier(
          SPaint(
            color: Colors.black,
            strokeWidth: 4,
            strokeCap: StrokeCap.round,
            strokeJoin: StrokeJoin.miter,
            style: PaintingStyle.stroke,
          ),
        );

  void undo() {
    if (!_inDrag && _paths.value.isNotEmpty) {
      final last = _paths.value.removeLast();
      _backupPaths.value.add(last);
      _paths.notifyListeners();
    }
  }

  void redo() {
    if (_backupPaths.value.isEmpty) {
      return;
    }

    final last = _backupPaths.value.removeLast();
    _paths.value.add(last);
    _paths.notifyListeners();
  }

  void clear() {
    if (!_inDrag) {
      _paths.value.clear();
      _backupPaths.value.clear();
      _paths.notifyListeners();
    }
  }

  void add(Offset startPoint) {
    _backupPaths.value.clear();
    if (!_inDrag) {
      _inDrag = true;
      _lastPoints.add(startPoint);
      _paths.value.add(
        SPath(
          points: [SPoint.move(startPoint.dx, startPoint.dy)],
          paint: currentPaint.value,
          rect: Rect.zero,
        ),
      );
      _paths.notifyListeners();
    }
  }

  void updateCurrent(Offset point) {
    if (_inDrag) {
      final lastPoint = _lastPoints.last;
      if ((lastPoint.dx - point.dx).abs() > 0.25 &&
          (lastPoint.dy - point.dy).abs() > 0.25) {
        _lastPoints.add(point);

        final last = _paths.value.last;

        _paths.value[_paths.value.length - 1] = _paths.value.last.copyWith(
          points: last.points..add(SPoint.line(point.dx, point.dy)),
        );

        _paths.notifyListeners();
      }
    }
  }

  void endCurrent() {
    _inDrag = false;
    if (_lastPoints.length <= 1 && _inDrag) {
      _paths.value.removeLast();
      _paths.notifyListeners();
    }
    _lastPoints.clear();
  }

  void draw(
    Canvas canvas,
    Size size, [
    void Function()? drawAfterSave,
  ]) {
    canvas.saveLayer(Offset.zero & size, Paint());

    drawAfterSave?.call();

    for (var path in _paths.value) {
      path.draw(canvas, size);
    }

    canvas.restore();
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PathHistory &&
            other.paths == paths);
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^ paths.hashCode ^ currentPaint.hashCode;

  PathHistory copyWith({
    Size? size,
    List<SPath>? paths,
  }) {
    return PathHistory(
      paths: paths ?? _paths.value,
      originalSize: size ?? originalSize,
    );
  }
}
