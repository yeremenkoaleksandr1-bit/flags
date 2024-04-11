import 'package:armar/armar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

abstract class ArField<S extends ArFieldState> extends StatefulWidget {
  const ArField({
    super.key,
    required this.fieldKey,
    this.initialValue,
    this.validator,
  });

  final String fieldKey;
  final String? initialValue;

  final String? Function(String?)? validator;

  @override
  State<ArField> createState() => ArFieldState();

  Widget build(BuildContext context, S state);
}

class ArFieldState extends State<ArField> {
  late final formState = ArFormBuilder.of(context)!;

  @override
  void dispose() {
    formState.removeInternalFieldValue(widget.fieldKey);
    super.dispose();
  }

  @override
  @nonVirtual
  Widget build(BuildContext context) => widget.build(
        context,
        this,
      );
}
