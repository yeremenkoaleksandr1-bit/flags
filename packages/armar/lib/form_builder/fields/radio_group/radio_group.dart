import 'package:armar/armar.dart';
import 'package:armar/rx/rx.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../logger.dart';
import '../states/text_form_field.state.dart';
import '../text_field.dart';

class ArFormBuilderRadioGroup<T> extends ArFormBuilderField<T> {
  ArFormBuilderRadioGroup({
    super.key,
    required super.name,
    required this.values,
    required this.buildField,
    required this.gap,
    required this.titleBy,
    required this.valueBy,
    super.onChanged,
    super.initialValue,
  }) : super(builder: (state) => Builder(builder: state.build));

  final List<dynamic> values;

  final Widget Function(String title, String value, String fieldValue)
      buildField;
  final Widget gap;

  final String Function(T item) titleBy;
  final String Function(T item) valueBy;


  @override
  ArFormBuilderFieldState<ArFormBuilderRadioGroup<T>, T> createState() =>
      ArFormBuilderRadioGroupState<T>();
}

class ArFormBuilderRadioGroupState<T>
    extends ArFormBuilderFieldState<ArFormBuilderRadioGroup<T>, T> {
  late final RxValue<T> _value =
      RxValue(widget.initialValue ?? widget.values.first);

  void _onValueChanged(T value) {
    _value.value = value;

    didChange(value);
  }

  @override
  Widget build(BuildContext context) {
    return FastValueBuilder(
      listen: _value,
      builder: (T value) {
        return SeparatedListView(
          gap: widget.gap,
          children: [
            ...widget.values.map(
              (e) => InkWell(
                onTap: () => _onValueChanged(e),
                child: widget.buildField(
                  widget.titleBy(e),
                  widget.valueBy(value),
                  widget.valueBy(e),
                ),
              ),
            )
          ],
        );
      },
    );
  }
}
