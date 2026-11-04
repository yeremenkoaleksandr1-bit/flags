import 'dart:async';

import 'package:reactive_forms/reactive_forms.dart';

abstract interface class IReactiveFormHandlerMixin {
  FormGroup get formGroup;

  FutureOr<void> handleFormData();
}

mixin ReactiveFormHandlerMixin implements IReactiveFormHandlerMixin {
  @override
  FutureOr<void> handleFormData() async {
    formGroup.markAllAsTouched();

    if (formGroup.valid) {
      await onFormDataHandle(formGroup);
    }

    formGroup.markAsEnabled();
  }

  FutureOr<void> onFormDataHandle(FormGroup form);
}
