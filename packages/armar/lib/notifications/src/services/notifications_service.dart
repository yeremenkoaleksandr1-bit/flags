import 'dart:ui';

import 'package:armar/armar.dart';
import 'package:armar/notifications/src/models/details/android_notification_details.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract interface class INotificationsService {
  static INotificationsService get get => Get.find<INotificationsService>();

  Future<void> pushNotification({
    String? title,
    String? body,
    Map<String, dynamic>? content,
  });
}

class NotificationsServiceImpl implements INotificationsService {
  int _id = 0;

  final String channelName;

  final void Function(NotificationResponse)? onDidReceiveNotificationResponse;

  final Color? defaultIconBackgroundColor;

  NotificationsServiceImpl({
    required this.channelName,
    required this.onDidReceiveNotificationResponse,
    this.defaultIconBackgroundColor,
  });

  Future<INotificationsService> init() async {
    _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    await _initializeNotification();

    return Get.put<INotificationsService>(this);
  }

  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  Future<void> _initializeNotification() async {
    // ignore: constant_identifier_names
    const DarwinInitializationSettings IOSInitializationSettings =
        DarwinInitializationSettings();

    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings("ic_notification");

    InitializationSettings initializationSettings =
        const InitializationSettings(
      iOS: IOSInitializationSettings,
      android: androidInitializationSettings,
    );

    await _localNotifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }

  @override
  Future<void> pushNotification({
    String? title,
    String? body,
    Map<String, dynamic>? content,
  }) async {
    final effectiveChannelId = "armar|${channelName}_channel";
    final effectiveChannelName = "armar|${channelName}_sound_channel";

    AndroidNotificationDetails? androidNotificationDetails;
    if (content != null) {
      if (content.containsKey("android_details")) {
        androidNotificationDetails =
            await ArAndroidNotificationDetails.fromJson(
          content['android_details'],
          channelId: effectiveChannelId,
          channelName: effectiveChannelName,
          defaultColor: defaultIconBackgroundColor,
        );
      }
    }

    return _localNotifications.show(
      _id++,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          effectiveChannelId,
          effectiveChannelName,
          color: defaultIconBackgroundColor,
          colorized: true,
          importance: Importance.max,
          priority: Priority.max,
          playSound: true,
          enableVibration: true,
          category: AndroidNotificationCategory.social,
        ).merge(androidNotificationDetails),
      ),
    );
  }
}
