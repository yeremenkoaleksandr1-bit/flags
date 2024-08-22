import 'dart:developer' as developer;
import 'get_main.dart';

///VoidCallback from logs
typedef LogWriterCallback = void Function(Object? object, {bool isError});

/// default logger from GetX
void defaultLogWriterCallback(Object? value, {bool isError = false}) {
  if (isError || Get.isLogEnable) {
    developer.log(value.toString(), name: 'GETX');
  }
}
