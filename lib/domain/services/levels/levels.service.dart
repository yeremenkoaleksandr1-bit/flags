import 'package:armar/armar.dart';
import 'package:hive/hive.dart';

import '../../domain.dart';

abstract interface class ILevelsService {
  static ILevelsService get I => Get.find<ILevelsService>();

  LevelModel? getLevelData({
    required int levelId,
    required ContinentType continent,
    required GameProcessType gameMode,
  });

  void saveLevel({
    required int levelId,
    required bool completed,
    required ContinentType continent,
    required GameProcessType gameMode,
    int seed = 1,
  });

  Stream<int> watchCompletedLevelsQuantity({
    required ContinentType continent,
    required GameProcessType gameMode,
  });

  int getCompletedLevelsQuantity({
    required ContinentType continent,
    required GameProcessType gameMode,
  });

  void removeDataOfContinent({
    required ContinentType continent,
    required GameProcessType gameMode,
  });
}

class LevelsServiceImpl implements ILevelsService {
  static const String _levelsBoxKey = "3294e1ce-1806-4ad2-a161-39854ced929f";

  final Box<LevelModel> _box = Hive.box<LevelModel>(name: _levelsBoxKey);

  Future<ILevelsService> initialize() async {
    return Get.put<ILevelsService>(this, permanent: true);
  }

  @override
  void saveLevel({
    required int levelId,
    required bool completed,
    required ContinentType continent,
    required GameProcessType gameMode,
    int seed = -1,
  }) {
    final model = LevelModel(
      id: levelId,
      completed: completed,
      seed: seed,
    );

    final key = "${gameMode.index}_${continent.index}_$levelId";

    _box.put(key, model);
  }

  @override
  LevelModel? getLevelData({
    required int levelId,
    required ContinentType continent,
    required GameProcessType gameMode,
  }) {
    final key = "${gameMode.index}_${continent.index}_$levelId";

    return _box.get(key);
  }

  @override
  Stream<int> watchCompletedLevelsQuantity({
    required ContinentType continent,
    required GameProcessType gameMode,
  }) {
    final streamController = _box.watch();
    final keyPrefix = "${gameMode.index}_${continent.index}_";

    return streamController.map<int>((event) {
      return _box.keys.where((element) => element.contains(keyPrefix)).length;
    });
  }

  @override
  int getCompletedLevelsQuantity(
      {required ContinentType continent, required GameProcessType gameMode}) {
    final keyPrefix = "${gameMode.index}_${continent.index}_";

    return _box.keys.where((element) => element.contains(keyPrefix)).length;
  }

  @override
  void removeDataOfContinent({
    required ContinentType continent,
    required GameProcessType gameMode,
  }) {
    final keyPrefix = "${gameMode.index}_${continent.index}_";
    final keys = _box.keys.where((element) => element.contains(keyPrefix));

    _box.deleteAll(keys);
  }
}
