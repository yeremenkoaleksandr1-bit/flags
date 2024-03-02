import 'dart:async';

import 'package:flutter/material.dart';

import '../../../get.dart';

extension _Empty on Object {
  bool _isEmpty() {
    final val = this;
    // if (val == null) return true;
    var result = false;
    if (val is Iterable) {
      result = val.isEmpty;
    } else if (val is String) {
      result = val.trim().isEmpty;
    } else if (val is Map) {
      result = val.isEmpty;
    }
    return result;
  }
}

mixin StateMixin<T> {
  T? _value;
  RxValue<GetStatus<T>> statusRx = RxValue(GetStatus.loading());

  GetStatus<T> get status {
    return statusRx.value;
  }

  T get state => value;

  set status(GetStatus<T> newStatus) {
    if (newStatus is SuccessStatus<T>) {
      _value = newStatus.data;
    }

    statusRx.value = newStatus;
  }

  @protected
  T get value {
    return _value as T;
  }

  @protected
  set value(T newValue) {
    _value = newValue;
  }

  @protected
  void change(GetStatus<T> status, {bool force = false}) {
    this.status = status;

    if (force) {
      statusRx.notify();
    }
  }

  void futurize(
    Future<T> Function() body, {
    T? initialData,
    String? errorMessage,
    bool useEmpty = true,
  }) {
    final compute = body;
    _value ??= initialData;
    compute().then((newValue) {
      if ((newValue == null || newValue._isEmpty()) && useEmpty) {
        status = GetStatus<T>.loading();
      } else {
        status = GetStatus<T>.success(newValue);
      }

      statusRx.notify();
    }, onError: (err) {
      status = GetStatus.error(errorMessage ?? err.toString());
      statusRx.notify();
    });
  }
}

typedef FuturizeCallback<T> = Future<T> Function(VoidCallback fn);

typedef VoidCallback = void Function();

/// GetNotifier has a native status and state implementation, with the
/// Get Lifecycle
abstract class GetNotifier<T> extends RxValue<T> with GetLifeCycleMixin {
  GetNotifier(T initial) : super(initial);
}

extension StateExt<T> on StateMixin<T> {
  Widget obx(
    NotifierBuilder<T?> widget, {
    Widget Function(String? error)? onError,
    Widget? onLoading,
    Widget? onEmpty,
    WidgetBuilder? onCustom,
  }) {
    return Builder(builder: (context) {
      return FastBuilder(() {
        final status = statusRx.value;

        if (status.isLoading) {
          return onLoading ?? const Center(child: CircularProgressIndicator());
        } else if (status.isError) {
          return onError != null
              ? onError(status.errorMessage)
              : Center(child: Text('A error occurred: ${status.errorMessage}'));
        } else if (status.isEmpty) {
          return onEmpty ?? nil;
        } else if (status.isSuccess) {
          return widget(value);
        } else if (status.isCustom) {
          return onCustom?.call(context) ?? nil;
        }
        return widget(value);
      });
    });
  }
}

typedef NotifierBuilder<T> = Widget Function(T state);

abstract class GetStatus<T> with Equality {
  const GetStatus();

  factory GetStatus.loading() => LoadingStatus<T>();

  factory GetStatus.error(String message) => ErrorStatus<T, String>(message);

  factory GetStatus.empty() => EmptyStatus<T>();

  factory GetStatus.success(T data) => SuccessStatus<T>(data);

  factory GetStatus.custom() => CustomStatus<T>();
}

class CustomStatus<T> extends GetStatus<T> {
  @override
  List get props => [];
}

class LoadingStatus<T> extends GetStatus<T> {
  @override
  List get props => [];
}

class SuccessStatus<T> extends GetStatus<T> {
  final T data;

  const SuccessStatus(this.data);

  @override
  List get props => [data];
}

class ErrorStatus<T, S> extends GetStatus<T> {
  final S? error;

  const ErrorStatus([this.error]);

  @override
  List get props => [error];
}

class EmptyStatus<T> extends GetStatus<T> {
  @override
  List get props => [];
}

extension StatusDataExt<T> on GetStatus<T> {
  bool get isLoading => this is LoadingStatus;

  bool get isSuccess => this is SuccessStatus;

  bool get isError => this is ErrorStatus;

  bool get isEmpty => this is EmptyStatus;

  bool get isCustom => !isLoading && !isSuccess && !isError && !isEmpty;

  String get errorMessage {
    final isError = this is ErrorStatus;
    if (isError) {
      final err = this as ErrorStatus;
      if (err.error != null && err.error is String) {
        return err.error as String;
      }
    }

    return '';
  }

  T? get data {
    if (this is SuccessStatus<T>) {
      final success = this as SuccessStatus<T>;
      return success.data;
    }
    return null;
  }
}
