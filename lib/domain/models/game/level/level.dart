import 'package:hive/hive.dart';

class LevelModel {
  final int id;

  final bool completed;

  final int seed;

  LevelModel({
    required this.id,
    required this.completed,
    required this.seed,
  });

  factory LevelModel.fromJson(Map<String, dynamic> json) {
    return LevelModel(
      id: json["af5b0872"],
      completed: json["57472cf5"],
      seed: json["5915be3a"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "af5b0872": id,
      "57472cf5": completed,
      "5915be3a": seed,
    };
  }

  static void registerAdapter() => Hive.registerAdapter(
        "LevelModel",
        (json) => LevelModel.fromJson(json),
      );
}
