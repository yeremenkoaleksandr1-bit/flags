part of 'validators.dart';

FormFieldValidator<String?> userNameFieldValidation() => FormBuilderValidators.compose([
  FormBuilderValidators.required(),
  CustomFormBuilderValidators.alphaDash(),
  FormBuilderValidators.minLength(2),
  FormBuilderValidators.maxLength(255),
]);

