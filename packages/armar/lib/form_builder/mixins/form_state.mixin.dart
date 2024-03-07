import 'package:armar/rx/rx.dart';
import 'package:flutter/material.dart';

import '../../armar.dart';
import '../../logger.dart';

abstract interface class IFormStatePresenter {
  GlobalKey<ArFormBuilderState> get formStateKey;
}

mixin FormStatePresenterMixin implements IFormStatePresenter {
  @override
  GlobalKey<ArFormBuilderState> formStateKey = GlobalKey<ArFormBuilderState>();

  ArFormBuilderState get formState => formStateKey.currentState!;

  final RxBool formIsValid = false.rx;

  final RxValue<FilterValues> savedFormState = FilterValues(data: {}).rx;
  final RxValue<FilterValues> currentFormState = FilterValues(data: {}).rx;

  bool getFormIsValid() => formIsValid.value;

  FilterValues getCurrentFormState() => currentFormState.value;

  FilterValues getCurrentSavedFormState() => savedFormState.value;

  void changeSavedFormState(Map<String, dynamic> data) {
    savedFormState.value = FilterValues(data: data);
  }

  void saveFormState() {
    onFormDataChanged();
    savedFormState.value = currentFormState.value;
  }

  void changeFormState(Map<String, dynamic> data) {
    currentFormState.value = FilterValues(data: data);
  }

  bool currentFormStateIsEqualSaved() =>
      savedFormState.value == currentFormState.value;

  void validateForm() {
    formIsValid.value = formState.validate();
  }

  void resetFormState() {
    formState.reset();
    changeFormState({});
    saveFormState();
  }

  void clearFormFields() {
    formState.clearFields();
  }

  void onFormDataChanged() {
    formState.save();
    changeFormState(formState.value);
  }

  void removeFieldFromState(String name) {
    formState.fields.removeWhere((key, value) => key == name);
  }

  void invalidateFormFields(Map<String, dynamic> errors) {
    errors.forEach((key, value) {
      invalidateFormField(
          key, (value is List ? value.first : value).toString());
    });
  }

  void invalidateFormField(String key, String value) {
    formState.fields[key]!.invalidate(value);
  }

  void formSetNewValues(Map<String, dynamic> data) {
    formState.fields.forEach((key, field) {
      final newValue = data[key];
      field.setValue(newValue);
    });
  }

  void sendFormData() async {
    //if(formStateKey.currentState == null) return;

    formState.save();

    if (formState.validate()) {
      await onFormDataSend(formState.value);
    } else {
      formInvalidFieldNotification();
    }
  }

  void formInvalidFieldNotification() {}

  Future<void> onFormDataSend(Map<String, dynamic> data);
}

mixin FormSendButtonStateMixin {
  RxValue<bool> get sendButtonActiveState;

  RxGetStatus get sendButtonState;

  void sendFormData();
}

mixin FormSendButtonMixin implements FormSendButtonStateMixin {
  @override
  final RxValue<bool> sendButtonActiveState = true.rx;
  @override
  final RxGetStatus sendButtonState = RxGetStatus(RxStatus.empty);

  void sendButtonSetActive() => changeSendButtonActiveStatus(true);

  void sendButtonSetDisable() => changeSendButtonActiveStatus(false);

  void changeSendButtonActiveStatus(bool value) =>
      sendButtonActiveState.value = value;

  void changeSendButtonStatus(RxStatus value) {
    sendButtonState.value = value;
  }
}

extension FormBuilderStateX on FormBuilderState {
  T getFieldValue<T>(String key, {T? defaultValue}) {
    return fields[key]?.value ?? defaultValue;
  }
}
