import 'package:hive/hive.dart';

class AppPreferencesData {
  bool activeSound;
  bool activeVibration;

  AppPreferencesData({
    required this.activeSound,
    required this.activeVibration,
  });

  Map<String, dynamic> toJson() => {
        'activeSound': activeSound,
        'activeVibration': activeVibration,
      };

  factory AppPreferencesData.fromJson(Map<String, dynamic> json) =>
      AppPreferencesData(
        activeSound: json['activeSound'] as bool,
        activeVibration: json['activeVibration'] as bool,
      );

  static void registerAdapter() => Hive.registerAdapter(
        "AppPreferences",
        (json) => AppPreferencesData.fromJson(json),
      );
}
