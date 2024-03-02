import 'package:flags/domain/game_objects/flag/flag.dart';
import 'package:flutter/cupertino.dart';

class GameLevel extends ChangeNotifier {
  int id = 0;
  final GameFlag flag;

  bool opened;
  bool completed;

  GameLevel({
    required this.flag,
    this.opened = false,
    this.completed = false,
  });

  void completeLevel() {
    completed = true;
    notifyListeners();
  }

  void openLevel() {
    opened = true;
    notifyListeners();
  }

  GameLevel copyWith({
    GameFlag Function(GameFlag oldFlag)? flag,
    bool? opened,
    bool? completed,
  }) {
    final level = GameLevel(
      flag: flag?.call(this.flag) ?? this.flag,
      opened: opened ?? this.opened,
      completed: completed ?? this.completed,
    );
    level.id = id;
    return level;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameLevel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          flag == other.flag;

  @override
  int get hashCode => id.hashCode ^ flag.hashCode;
}
