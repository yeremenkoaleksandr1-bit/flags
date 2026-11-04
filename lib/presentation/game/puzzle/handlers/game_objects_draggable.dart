import 'package:flutter/cupertino.dart';

mixin ProcessedObjectFocusHandler {
  final ValueNotifier<dynamic> _object = ValueNotifier(null);

  ValueNotifier<dynamic> get focusedObject => _object;

  void unfocusObject() {
    if (_object.value != null) {
      onObjectFocusRemoved(_object.value!);
    }
    _object.value = null;
  }

  void setFocusOnObject(Object object) {
    _object.value = object;
    onObjectFocusAdded(object);
  }

  void onObjectFocusRemoved(Object object);

  void onObjectFocusAdded(Object object);

  void disposeProcessedObjectFocusHandler() {
    _object.dispose();
  }
}
