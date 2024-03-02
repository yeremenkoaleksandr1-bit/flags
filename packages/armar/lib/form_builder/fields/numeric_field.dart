import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'text_field.dart';

class ArFormBuilderNumeric extends ArFormBuilderTextField {
  ArFormBuilderNumeric({
    super.key,
    required super.name,
    super.validator,
    super.initialValue,
    InputDecoration? decoration,
    super.onChanged,
    super.valueTransformer,
    super.enabled,
    super.onSaved,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.onReset,
    super.focusNode,
    super.restorationId,
    List<TextInputFormatter>? inputFormatters,
  }) : super(
          decoration: (context) => decoration ?? const InputDecoration(),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
            ...?inputFormatters,
          ],
        );
}
