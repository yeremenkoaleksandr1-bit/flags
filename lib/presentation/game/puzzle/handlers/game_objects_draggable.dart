import 'package:flags/shared/services/disposable.dart';
import 'package:flutter/cupertino.dart';
import 'package:state_manager/state_manager.dart';

mixin ProcessedObjectFocusHandler implements IDisposable {
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

  @override
  void dispose() {
    _object.dispose();
  }
}
