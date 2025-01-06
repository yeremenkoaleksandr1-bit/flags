import 'package:equatable/equatable.dart';

class AppPreferencesData extends Equatable {
  final bool activeSound;
  final bool activeVibration;

  final bool isDebugMode;

  const AppPreferencesData({
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

  AppPreferencesData copyWith({
    bool? activeSound,
    bool? activeVibration,
    bool? isDebugMode,
  }) {
    return AppPreferencesData(
      activeSound: activeSound ?? this.activeSound,
      activeVibration: activeVibration ?? this.activeVibration,
      isDebugMode: isDebugMode ?? this.isDebugMode,
    );
  }


  @override
  List<Object?> get props => [
        activeSound,
        activeVibration,
        isDebugMode,
      ];

}
