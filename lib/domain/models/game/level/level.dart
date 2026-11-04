import 'package:equatable/equatable.dart';

class LevelProcessData extends Equatable {
  final bool completed;

  final int seed;

  const LevelProcessData({
    required this.completed,
    required this.seed,
  });

  static LevelProcessData decode(String data) {
    final parts = data.split('|');
    final completed = parts[0] == 'true';
    final seed = int.parse(parts[1]);

    return LevelProcessData(
      completed: completed,
      seed: seed,
    );
  }

  String encode() {
    return "$completed|$seed";
  }

  @override
  List<Object?> get props => [
        completed,
        seed,
      ];
}
