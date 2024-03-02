part of 'validators.dart';

FormFieldValidator<String?> emailFieldValidation() => FormBuilderValidators.compose([
  FormBuilderValidators.required(),
  FormBuilderValidators.email(),
  FormBuilderValidators.maxLength(255),
]);
