part of 'validators.dart';

FormFieldValidator<String?> passwordFieldValidation() =>
    FormBuilderValidators.compose([
      FormBuilderValidators.required(),
      FormBuilderValidators.minLength(8),
      FormBuilderValidators.maxLength(255),
      FormBuilderValidators.match(
        r'[A-Z]',
        errorText: "Пароль повинен містити хоча б одну велику літеру",
      ),
      FormBuilderValidators.match(
        r'[a-z]',
        errorText: "Пароль повинен містити хоча б одну малу літеру",
      ),
      FormBuilderValidators.match(
        r'[0-9]',
        errorText: "Пароль повинен містити хоча б одну цифру",
      ),
    ]);

FormFieldValidator<String?> passwordConfirmationFieldValidation(
  String originalPassword,
) =>
    FormBuilderValidators.compose([
      FormBuilderValidators.required(),
      FormBuilderValidators.equal(
        originalPassword,
        errorText: "Паролі мають співпадати",
      ),
    ]);

FormFieldValidator<String?> passwordSignUpFieldValidation() =>
    FormBuilderValidators.compose([
      FormBuilderValidators.required(),
      FormBuilderValidators.minLength(6),
      FormBuilderValidators.maxLength(255),
      FormBuilderValidators.minLength(8,
          errorText: 'Password must be at least 8 characters long'),
      FormBuilderValidators.match(
        r'^(?=.*[0-9])(?=.*[a-zA-Z])([a-zA-Z0-9]+)$',
        errorText: 'Password must contain at least one number and one letter',
      ),
    ]);
