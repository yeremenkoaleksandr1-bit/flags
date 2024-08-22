import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:state_manager/src/get.dart';

abstract interface class IStateMixin<T> {
  GetStatus<T> get status;

  ValueListenable<GetStatus<T>> get statusListener;

  T get value;

  T get state;
}

mixin StateMixin<T> implements IStateMixin<T> {
  T? _value;
  ValueNotifier<GetStatus<T>> statusRx = ValueNotifier(const LoadingStatus());

  @override
  ValueListenable<GetStatus<T>> get statusListener => statusRx;

  @override
  GetStatus<T> get status {
    return statusRx.value;
  }

  @override
  T get state => value;

  set status(GetStatus<T> newStatus) {
    if (newStatus is SuccessStatus<T>) {
      _value = newStatus.data;
    }

    statusRx.value = newStatus;
  }

  @override
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
      statusRx.notifyListeners();
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
    compute().then(
      (newValue) {
        if ((newValue == null || newValue._isEmpty()) && useEmpty) {
          status = LoadingStatus();
        } else {
          status = SuccessStatus(newValue);
        }

        statusRx.notifyListeners();
      },
      onError: (err) {
        status = ErrorStatus(errorMessage ?? err.toString());
        statusRx.notifyListeners();
      },
    );
  }

  void disposeState() {
    statusRx.dispose();
  }
}

typedef NotifierBuilder<T> = Widget Function(T state);

abstract class GetStatus<T> with Equality {
  const GetStatus();
}

class CustomStatus<T> extends GetStatus<T> {
  @override
  List<dynamic> get props => [];
}

class LoadingStatus<T> extends GetStatus<T> {
  const LoadingStatus();

  @override
  List<T> get props => [];
}

class SuccessStatus<T> extends GetStatus<T> {
  final T data;

  const SuccessStatus(this.data);

  @override
  List<T> get props => [data];
}

class ErrorStatus<T, S> extends GetStatus<T> {
  final S? error;

  const ErrorStatus([this.error]);

  @override
  List get props => [error];
}

class EmptyStatus<T> extends GetStatus<T> {
  const EmptyStatus();

  @override
  List<T> get props => [];
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
