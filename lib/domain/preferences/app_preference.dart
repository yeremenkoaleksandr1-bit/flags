import 'package:flags/domain/models/app/app.dart';
import 'package:hive/hive.dart';

class AppPreferences {
  AppPreferences() {
    data = box.get("data") ??
        AppPreferencesData(
          activeSound: true,
          activeVibration: true,
        );
  }

  late final AppPreferencesData data;
  final Box<AppPreferencesData> box =
      Hive.box<AppPreferencesData>(name: "app_preferences");

  void setActiveSound(bool value) {
    data.activeSound = value;
    _save(data);
  }

  void setActiveVibration(bool value) {
    data.activeVibration = value;

    _save(data);
  }

  void _save(AppPreferencesData value) {
    box.put("data", value);
  }
}
