import 'dart:collection';

import 'package:flutter/foundation.dart';

abstract class ValueListenableList<T> extends ValueListenable<List<T>> {}

class ValueNotifierList<T> extends ValueNotifier<List<T>>
    with ListMixin<T>
    implements ValueListenableList<T> {
  ValueNotifierList([List<T>? value]) : super(value ?? <T>[]);

  @override
  int get length => value.length;

  @override
  set length(int value) {
    this.value.length = value;
    notifyListeners();
  }

  @override
  T operator [](int index) {
    return value[index];
  }

  @override
  void operator []=(int index, T value) {
    this.value[index] = value;
    notifyListeners();
  }

  @override
  void add(T element) {
    value.add(element);
    notifyListeners();
  }

  @override
  void clear() {
    value.clear();
    notifyListeners();
  }

  @override
  void insert(int index, T element) {
    value.insert(index, element);
    notifyListeners();
  }

  @override
  void addAll(Iterable<T> iterable) {
    value.addAll(iterable);
    notifyListeners();
  }

  @override
  bool remove(Object? element) {
    final value = this.value.remove(element);
    notifyListeners();
    return value;
  }

  @override
  T removeAt(int index) {
    final value = this.value.removeAt(index);
    notifyListeners();
    return value;
  }
}
