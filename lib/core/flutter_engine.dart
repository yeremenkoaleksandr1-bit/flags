import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';

abstract class FlutterEngine {
  const FlutterEngine._();

  static void widgetPostFrameCallback(
    void Function(Duration timeStamp) onCall,
  ) {
    WidgetsBinding.instance.addPostFrameCallback(onCall);
  }

  static void schedulePostFrameCallback(
    void Function(Duration timeStamp) onCall,
  ) {
    SchedulerBinding.instance.addPostFrameCallback(onCall);
  }
}
