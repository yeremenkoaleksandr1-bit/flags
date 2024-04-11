import 'package:armar/armar.dart';
import 'package:flags/uikit/form/fields/field.dart';
import 'package:flutter/material.dart';

class FTextField extends ArField {
  const FTextField({
    super.key,
    super.initialValue,
    required super.fieldKey,
    super.validator,
    this.placeholder,
  });

  final String? placeholder;

  @override
  Widget build(BuildContext context, ArFieldState state) {
    return ArFormBuilderTextField(
      name: fieldKey,
      initialValue: initialValue,
      validator: validator,
      textCapitalization: TextCapitalization.words,
      decoration: (_) => InputDecoration(
        hintText: placeholder,
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 2,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.5,
          ),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
