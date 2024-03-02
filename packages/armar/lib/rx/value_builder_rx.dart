import 'package:armar/armar.dart';
import 'package:flutter/material.dart';

class FastValueBuilder<T> extends FastBuilder {
  FastValueBuilder({
    super.key,
    required RxValue<T> listen,
    required Widget Function(T value) builder,
    super.condition,
  }) : super(() => builder(listen.value));
}

extension FastValueBuilderX<T> on RxValue<T> {
  Widget build(
          {required Widget Function(T value) builder,
          ValueGetter<bool>? condition}) =>
      FastValueBuilder<T>(
        listen: this,
        builder: builder,
      );
}
