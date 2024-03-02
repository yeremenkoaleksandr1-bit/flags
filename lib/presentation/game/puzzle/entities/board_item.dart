import 'package:armar/armar.dart';
import 'package:flags/domain/game_objects/base/process.game_object.dart';

class BoardItem<T extends ProcessGameObject> {
  final T object;
  final RxValue<bool> active;

  void setActive(bool value) => active.value = value;

  BoardItem({
    required this.object,
  }) : active = RxValue(true);

  BoardItem copyWith({
    T? object,
  }) {
    final instance = BoardItem(
      object: object ?? this.object,
    );
    instance.active.value = active.value;

    return instance;
  }

  @override
  bool operator ==(Object other) =>
      other is BoardItem && object == other.object;

  @override
  int get hashCode => object.hashCode;
}
