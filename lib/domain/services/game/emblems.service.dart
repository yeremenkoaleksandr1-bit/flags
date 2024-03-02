import 'package:armar/armar.dart';
import 'package:hive/hive.dart';

abstract interface class IEmblemsService {
  static IEmblemsService get I => Get.find<IEmblemsService>();

  bool isOpened(String emblemName);

  void saveEmblem(String emblemName);
}

class EmblemsServiceImpl implements IEmblemsService {
  static const String _emblemsBoxKey = "2416ab90-03d4-4c53-933e-5687074039a5";
  final Box<bool> _openedEmblemsBox = Hive.box<bool>(name: _emblemsBoxKey);

  Future<IEmblemsService> initialize() async {
    return Get.put<IEmblemsService>(this, permanent: true);
  }

  @override
  bool isOpened(String emblemName) {
    return _openedEmblemsBox.containsKey(emblemName);
  }

  @override
  void saveEmblem(String emblemName) {
    _openedEmblemsBox.put(emblemName, true);
  }
}
