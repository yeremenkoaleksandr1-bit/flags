import 'package:flutter/material.dart';

import '../armar.dart';


export 'rx_status_view.dart';
export 'value_builder_rx.dart';

enum RxStatus {
  empty,
  loading,
  error,
  success,
}

extension RxBuilderX<T> on RxValue<T> {
  Widget build({
    required Widget Function(T value) builder,
    Key? key,
    bool Function()? condition,
  }) {
    return FastBuilder(
      () => builder(value),
      key: key,
      condition: condition,
    );
  }
}

extension RxStatusX on RxStatus {
  bool get isEmpty => this == RxStatus.empty;

  bool get isLoading => this == RxStatus.loading;

  bool get isError => this == RxStatus.error;

  bool get isSuccess => this == RxStatus.success;
}

class RxGetStatus extends RxValue<RxStatus> {
  RxGetStatus(RxStatus initial) : super(initial);

  void setLoading() => value = RxStatus.loading;

  void setEmpty() => value = RxStatus.empty;

  void setError() => value = RxStatus.error;

  void setSuccess() => value = RxStatus.success;

  @override
  String toString() => value.toString();
}
