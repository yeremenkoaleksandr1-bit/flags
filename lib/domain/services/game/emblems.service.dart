import 'package:shared_preferences/shared_preferences.dart';

abstract interface class IEmblemsService {
  bool isOpened(String emblemName);

  Future<void> saveEmblem(String emblemName);
}

class EmblemsServiceImpl implements IEmblemsService {
  final SharedPreferences _prefs;

  EmblemsServiceImpl(this._prefs);

  @override
  bool isOpened(String emblemName) {
    return _prefs.getBool(emblemName) ?? false;
  }

  @override
  Future<void> saveEmblem(String emblemName) async {
    await _prefs.setBool(emblemName, true);
  }
}
