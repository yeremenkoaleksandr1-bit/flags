import 'dart:ui';

import 'package:armar/armar.dart';
import 'package:armar/state_management/get_utils/src/extensions/internacionalization.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ArAndroidNotificationDetails extends AndroidNotificationDetails {
  ArAndroidNotificationDetails(
    super.channelId,
    super.channelName, {
    super.channelDescription,
    super.icon,
    super.importance = Importance.defaultImportance,
    super.priority = Priority.defaultPriority,
    super.styleInformation,
    super.playSound = true,
    super.sound,
    super.enableVibration = true,
    super.vibrationPattern,
    super.groupKey,
    super.setAsGroupSummary = false,
    super.groupAlertBehavior = GroupAlertBehavior.all,
    super.autoCancel = true,
    super.ongoing = false,
    super.color,
    super.largeIcon,
    super.onlyAlertOnce = false,
    super.showWhen = true,
    super.when,
    super.usesChronometer = false,
    super.chronometerCountDown = false,
    super.channelShowBadge = true,
    super.showProgress = false,
    super.maxProgress = 0,
    super.progress = 0,
    super.indeterminate = false,
    super.channelAction = AndroidNotificationChannelAction.createIfNotExists,
    super.enableLights = false,
    super.ledColor,
    super.ledOnMs,
    super.ledOffMs,
    super.ticker,
    super.visibility,
    super.timeoutAfter,
    super.category,
    super.fullScreenIntent = false,
    super.shortcutId,
    super.additionalFlags,
    super.subText,
    super.tag,
    super.actions,
    super.colorized = false,
    super.number,
    super.audioAttributesUsage,
  });

  static Future<ArAndroidNotificationDetails> fromJson(
    Map<String, dynamic> json, {
    required String channelId,
    required String channelName,
    Color? defaultColor,
  }) async {
    String? imageUrl = json['image_url'];
    String? langeIconUrl = json['large_icon_url'];

    StyleInformation? styleInformation;
    AndroidBitmap<Object>? imageBitmap;
    AndroidBitmap<Object>? largeIconBitmap;

    if (imageUrl != null && imageUrl.isNotEmpty) {
      final imageBytes = await UrlImage.loadNetworkImageBytes(imageUrl);
      imageBitmap = ByteArrayAndroidBitmap(imageBytes);
      styleInformation = BigPictureStyleInformation(
        imageBitmap,
        hideExpandedLargeIcon: true,
      );
    }

    if (langeIconUrl != null && langeIconUrl.isNotEmpty) {
      if (imageUrl != null && imageUrl == langeIconUrl) {
        largeIconBitmap = imageBitmap;
      } else {
        final imageBytes = await UrlImage.loadNetworkImageBytes(langeIconUrl);
        largeIconBitmap = ByteArrayAndroidBitmap(imageBytes);
      }
    }

    final category = AndroidNotificationCategory.values.firstWhereOrNull(
      (e) => e.name == json['category'],
    );

    final enableVibration = json['enable_vibration'] ?? true;
    final playSound = json['play_sound'] ?? true;
    final colorized = json['colorized'] ?? true;
    final autoCancel = json['auto_cancel'] ?? true;
    final subText = json['sub_text'];

    final priority = Priority.values.firstWhere(
      (e) => e.value == json['priority'],
      orElse: () => Priority.defaultPriority,
    );

    final importance = Importance.values.firstWhere(
      (e) => e.value == json['importance'],
      orElse: () => Importance.defaultImportance,
    );

    final audioAttributesUsage = AudioAttributesUsage.values.firstWhere(
      (e) => e.value == json['audio_attributes_usage'],
      orElse: () => AudioAttributesUsage.notification,
    );

    final color =
        json['color'] != null ? HexColor.fromHex(json['color']) : defaultColor;

    return ArAndroidNotificationDetails(
      channelId,
      channelName,
      color: color,
      colorized: colorized,
      importance: importance,
      priority: priority,
      playSound: playSound,
      enableVibration: enableVibration,
      category: category,
      styleInformation: styleInformation,
      largeIcon: largeIconBitmap ?? imageBitmap,
      autoCancel: autoCancel,
      subText: subText,
      audioAttributesUsage: audioAttributesUsage,
    );
  }
}

extension AndroidNotificationDetailsMerge on AndroidNotificationDetails {
  AndroidNotificationDetails merge(AndroidNotificationDetails? other) {
    if (other == null) {
      return this;
    }
    return AndroidNotificationDetails(
      other.channelId,
      other.channelName,
      channelDescription: other.channelDescription ?? channelDescription,
      icon: other.icon ?? icon,
      importance: other.importance,
      priority: other.priority,
      styleInformation: other.styleInformation ?? styleInformation,
      playSound: other.playSound,
      sound: other.sound ?? sound,
      enableVibration: other.enableVibration,
      vibrationPattern: other.vibrationPattern ?? vibrationPattern,
      groupKey: other.groupKey ?? groupKey,
      setAsGroupSummary: other.setAsGroupSummary,
      groupAlertBehavior: other.groupAlertBehavior,
      autoCancel: other.autoCancel,
      ongoing: other.ongoing,
      color: other.color ?? color,
      largeIcon: other.largeIcon ?? largeIcon,
      onlyAlertOnce: other.onlyAlertOnce,
      showWhen: other.showWhen,
      when: other.when ?? when,
      usesChronometer: other.usesChronometer,
      chronometerCountDown: other.chronometerCountDown,
      channelShowBadge: other.channelShowBadge,
      showProgress: other.showProgress,
      maxProgress: other.maxProgress,
      progress: other.progress,
      indeterminate: other.indeterminate,
      channelAction: other.channelAction,
      enableLights: other.enableLights,
      ledColor: other.ledColor ?? ledColor,
      ledOnMs: other.ledOnMs ?? ledOnMs,
      ledOffMs: other.ledOffMs ?? ledOffMs,
      ticker: other.ticker ?? ticker,
      visibility: other.visibility ?? visibility,
      timeoutAfter: other.timeoutAfter ?? timeoutAfter,
      category: other.category ?? category,
      fullScreenIntent: other.fullScreenIntent,
      shortcutId: other.shortcutId ?? shortcutId,
      additionalFlags: other.additionalFlags ?? additionalFlags,
      actions: other.actions ?? actions,
      subText: other.subText ?? subText,
      tag: other.tag ?? tag,
      colorized: other.colorized,
      number: other.number ?? number,
      audioAttributesUsage: other.audioAttributesUsage,
    );
  }
}
