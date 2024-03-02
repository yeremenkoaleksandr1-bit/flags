import 'package:flutter/widgets.dart';

enum ConsistentWidgetBuilderStatus {
  ready,
  building,
  waiting,
}

class ConsistentWidgetBuilderNotification extends Notification {
  final ConsistentWidgetBuilderStatus status;

  ConsistentWidgetBuilderNotification({required this.status});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConsistentWidgetBuilderNotification &&
          runtimeType == other.runtimeType &&
          status == other.status;

  @override
  int get hashCode => status.hashCode;
}
