import 'dart:ui';

class SDragTargetDetails<T> {
  SDragTargetDetails({
    required this.data,
    required this.offset,
  });

  final T data;

  final Offset offset;
}
