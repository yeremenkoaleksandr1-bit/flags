part of 'validators.dart';

FormFieldValidator<String?> phoneFieldValidation() => FormBuilderValidators.compose([
  FormBuilderValidators.required(),
  FormBuilderValidators.minLength(6),
  FormBuilderValidators.maxLength(255),
]);
