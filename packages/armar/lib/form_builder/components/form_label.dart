import 'package:armar/armar.dart';
import 'package:armar/form_builder/themes/form_field.theme.dart';
import 'package:flutter/material.dart';

class ArFieldLabel extends StatelessWidget {
  const ArFieldLabel({
    super.key,
    required this.title,
    required this.field,
  });

  final Widget title;
  final Widget field;

  @override
  Widget build(BuildContext context) {
    final labelTheme = Theme.of(context).extension<ArLabelFieldTheme>();
    final baseTextTheme = context.bodyMedium!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        DefaultTextStyle(
          style: baseTextTheme.merge(labelTheme?.labelStyle),
          child: title,
        ),
        SizedBox(
          height: labelTheme?.spaceBetween,
        ),
        field,
      ],
    );
  }
}
