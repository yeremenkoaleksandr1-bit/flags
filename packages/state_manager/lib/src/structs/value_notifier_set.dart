import 'dart:collection';
import 'package:flutter/foundation.dart';

class ValueNotifierSet<T> extends ValueNotifier<Set<T>> with SetMixin<T> {
  ValueNotifierSet([Set<T>? initialSet]) : super(initialSet ?? {});

  Set<T> get _set => value;

  @override
  bool add(T value) {
    final result = _set.add(value);
    if (result) {
      notifyListeners();
    }
    return result;
  }

  @override
  bool contains(Object? element) {
    return _set.contains(element);
  }

  @override
  Iterator<T> get iterator => _set.iterator;

  @override
  int get length => _set.length;

  @override
  T? lookup(Object? element) {
    return _set.lookup(element);
  }

  @override
  bool remove(Object? value) {
    final result = _set.remove(value);

    return result;
  }

  @override
  Set<T> toSet() {
    return _set.toSet();
  }
}
