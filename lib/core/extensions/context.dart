import 'package:flutter/widgets.dart';

extension CRenderBoxExtension on RenderBox {
  Rect get rect => localToGlobal(Offset.zero) & size;
}

extension ContextRenderBoxExtension on BuildContext {
  RenderBox? get renderBox => findRenderObject() as RenderBox?;

  Rect? get globalPaintBounds {
    final renderObject = findRenderObject();
    final matrix = renderObject?.getTransformTo(null);

    if (matrix != null && renderObject?.paintBounds != null) {
      final rect = MatrixUtils.transformRect(matrix, renderObject!.paintBounds);
      return rect;
    } else {
      return null;
    }
  }
}
