import 'package:armar/armar.dart';

mixin ProcessedObjectFocusHandler {
  final RxValue<dynamic> _object = RxValue(null);

  RxValue<dynamic> get focusedObject => _object;

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
}
