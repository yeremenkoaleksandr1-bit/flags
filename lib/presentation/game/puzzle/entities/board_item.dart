import 'package:flags/domain/game_objects/base/process.game_object.dart';
import 'package:flags/shared/services/disposable.dart';
import 'package:flutter/material.dart';

class BoardItem<T extends ProcessGameObject> implements IDisposable {
  final T object;
  final ValueNotifier<bool> active;

  final Widget Function(Widget instance)? build;

  void setActive(bool value) {
    active.value = value;
  }

  BoardItem({
    required this.object,
    this.build,
  }) : active = ValueNotifier(true);

  BoardItem copyWith({
    T? object,
  }) {
    final instance = BoardItem(
      object: object ?? this.object,
      build: build,
    );

    instance.active.value = active.value;

    return instance;
  }

  @override
  void dispose() {
    active.dispose();
  }

  @override
  bool operator ==(Object other) =>
      other is BoardItem &&
      runtimeType == other.runtimeType &&
      object == other.object &&
      active.value == other.active.value;

  @override
  int get hashCode => object.hashCode ^ active.value.hashCode;
}
