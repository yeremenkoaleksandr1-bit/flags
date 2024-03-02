part of 'validators.dart';

FormFieldValidator<String?> companyTitleFieldValidation(BuildContext context) =>
    FormBuilderValidators.compose([
      FormBuilderValidators.required(),
      FormBuilderValidators.minLength(2),
      FormBuilderValidators.maxLength(255),
    ]);
