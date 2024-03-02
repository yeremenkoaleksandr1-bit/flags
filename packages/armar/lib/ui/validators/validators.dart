import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

part 'email.dart';

part 'password.dart';

part 'phone.dart';

part 'company_title.dart';

part 'user.dart';

abstract class CustomFormBuilderValidators {
  static FormFieldValidator<String> alphaDash({
    String? errorText,
  }) =>
      (valueCandidate) => true == valueCandidate?.isNotEmpty &&
              !RegExp(r'^[a-zA-Z0-9_-]+$').hasMatch(valueCandidate!)
          ? errorText ?? FormBuilderLocalizations.current.matchErrorText
          : null;

  static FormFieldValidator<String> httpSite(
    String site, {
    String? errorText,
  }) =>
      (valueCandidate) => true == valueCandidate?.isNotEmpty &&
              !RegExp(r"https://(www.)?" + site + r"/w+")
                  .hasMatch(valueCandidate!)
          ? errorText ?? FormBuilderLocalizations.current.matchErrorText
          : null;

  static FormFieldValidator<String> condition(
    bool Function(String? data) condition, {
    String? errorText,
  }) =>
      (valueCandidate) => condition(valueCandidate) == false
          ? errorText ?? FormBuilderLocalizations.current.matchErrorText
          : null;

  static FormFieldValidator<String> numberCondition(
    bool Function(int? data) condition, {
    String? errorText,
  }) =>
      (valueCandidate) => condition(valueCandidate != null
                  ? int.tryParse(valueCandidate)
                  : null) ==
              false
          ? errorText ?? FormBuilderLocalizations.current.matchErrorText
          : null;

  static FormFieldValidator<String> numberMoreThanZero({
    String? errorText,
  }) =>
      (valueCandidate) => numberCondition(
                (value) => value != null ? value > 0 : false,
              )(valueCandidate) !=
              null
          ? errorText ?? FormBuilderLocalizations.current.matchErrorText
          : null;
}

class MinMaxIntValueTextInputFormatter extends TextInputFormatter {
  final int maxValue;
  final int minValue;

  MinMaxIntValueTextInputFormatter(this.minValue, this.maxValue);

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    try {
      if (newValue.text.isEmpty) {
        return TextEditingValue(
          text: minValue.toString(),
          selection: TextSelection.collapsed(
            offset: minValue.toString().length,
          ),
        );
      }

      final int value = int.parse(newValue.text);

      if (value > maxValue) {
        return TextEditingValue(
          text: maxValue.toString(),
          selection:
              TextSelection.collapsed(offset: maxValue.toString().length),
        );
      } else if (value < minValue) {
        return TextEditingValue(
          text: minValue.toString(),
          selection:
              TextSelection.collapsed(offset: minValue.toString().length),
        );
      }
    } catch (e) {}

    return newValue;
  }
}
