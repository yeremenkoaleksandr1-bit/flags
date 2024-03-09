import 'package:hive/hive.dart';

class AppPreferencesData {
  bool activeSound;
  bool activeVibration;

  bool isDebugMode;

  AppPreferencesData({
    required this.activeSound,
    required this.activeVibration,
    required this.isDebugMode,
  });

  Map<String, dynamic> toJson() => {
        'activeSound': activeSound,
        'activeVibration': activeVibration,
        'isDebugMode': isDebugMode,
      };

  factory AppPreferencesData.fromJson(Map<String, dynamic> json) =>
      AppPreferencesData(
        activeSound: json['activeSound'],
        activeVibration: json['activeVibration'],
        isDebugMode: json['isDebugMode'],
      );

  static void registerAdapter() => Hive.registerAdapter(
        "AppPreferences",
        (json) => AppPreferencesData.fromJson(json),
      );
}
