import 'dart:ui' as ui;

import 'package:armar/form_builder/fields/themes/date_picker.theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../armar.dart';
import 'date_time_picker.dart';

class ArFormBuilderDatePicker extends StatefulWidget {
  const ArFormBuilderDatePicker({
    super.key,
    required this.name,
    this.validator,
    this.initialValue,
    this.onChanged,
    this.valueTransformer,
    this.enabled = true,
    this.onSaved,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.onReset,
    this.focusNode,
    this.restorationId,
    this.showedPasswordIcon,
    this.hiddenPasswordIcon,
    this.decoration,
    this.controller,
    this.errors,
    this.keyboardType = TextInputType.datetime,
    this.textInputAction,
    this.style,
    this.strutStyle,
    this.textAlignVertical,
    this.textDirection,
    this.minLines,
    this.showCursor,
    this.maxLength,
    this.onEditingComplete,
    this.inputFormatters,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.mouseCursor,
    this.buildCounter,
    this.obscuringCharacter = "*",
    this.maxLines = 1,
    this.obscureText = false,
    this.textCapitalization = TextCapitalization.none,
    this.scrollPadding = const EdgeInsets.all(20.0),
    this.enableInteractiveSelection = true,
    this.maxLengthEnforcement,
    this.textAlign = TextAlign.start,
    this.autofocus = false,
    this.autocorrect = true,
    this.cursorWidth = 2.0,
    this.expands = false,
    this.format,
    this.initialDate,
    this.initialDatePickerMode = DatePickerMode.day,
  });

  final String name;

  final InputDecoration? decoration;
  final FormFieldSetter<String>? onSaved;

  final String? Function(DateTime?)? validator;

  final String? initialValue;

  final bool enabled;

  final AutovalidateMode autovalidateMode;

  final String? restorationId;

  final IconData? showedPasswordIcon;
  final IconData? hiddenPasswordIcon;

  final ValueTransformer<String?>? valueTransformer;

  final void Function(DateTime?)? onChanged;

  final VoidCallback? onReset;

  final FocusNode? focusNode;

  final String obscuringCharacter;

  final TextEditingController? controller;
  final List<String>? errors;

  final TextInputType keyboardType;

  final TextInputAction? textInputAction;

  final TextCapitalization textCapitalization;

  final TextStyle? style;

  final StrutStyle? strutStyle;

  final TextAlign textAlign;

  final TextAlignVertical? textAlignVertical;

  final TextDirection? textDirection;

  final bool autofocus;

  final bool obscureText;

  final bool autocorrect;

  final int? maxLines;

  final int? minLines;

  final bool expands;

  final bool? showCursor;

  static const int noMaxLength = -1;

  final int? maxLength;

  final MaxLengthEnforcement? maxLengthEnforcement;

  final VoidCallback? onEditingComplete;

  final List<TextInputFormatter>? inputFormatters;

  final double cursorWidth;

  final Radius? cursorRadius;

  final ui.Color? cursorColor;

  final Brightness? keyboardAppearance;

  final EdgeInsets scrollPadding;

  final bool enableInteractiveSelection;

  bool get selectionEnabled => enableInteractiveSelection;

  final MouseCursor? mouseCursor;

  final InputCounterWidgetBuilder? buildCounter;

  final DateFormat? format;

  final DatePickerMode initialDatePickerMode;
  final DateTime? initialDate;

  @override
  ArPasswordDatePickerState createState() => ArPasswordDatePickerState();
}

class ArPasswordDatePickerState extends State<ArFormBuilderDatePicker> {
  late final FocusNode _effectiveFocusNode = widget.focusNode ?? FocusNode();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ArFormBuilderDatePickerTheme>()!;

    return ArFormBuilderDateTimePicker(
      name: widget.name,
      format: widget.format,
      obscureText: false,
      validator: widget.validator,
      controller: widget.controller,
      onChanged: widget.onChanged,
      restorationId: widget.restorationId,
      focusNode: _effectiveFocusNode,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      inputType: InputType.date,
      style: (context.bodyMedium ?? widget.style)?.apply(
        fontSizeFactor: 1,
        heightFactor: 1,
      ),
      strutStyle: widget.strutStyle,
      textAlign: widget.textAlign,
      textAlignVertical: widget.textAlignVertical,
      textDirection: widget.textDirection,
      textCapitalization: widget.textCapitalization,
      autofocus: widget.autofocus,
      showCursor: widget.showCursor ?? false,
      autocorrect: widget.autocorrect,
      maxLengthEnforcement:
          widget.maxLengthEnforcement ?? MaxLengthEnforcement.none,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      expands: widget.expands,
      maxLength: widget.maxLength,
      onEditingComplete: widget.onEditingComplete,
      inputFormatters: widget.inputFormatters,
      cursorWidth: widget.cursorWidth,
      cursorRadius: widget.cursorRadius,
      cursorColor: widget.cursorColor,
      scrollPadding: widget.scrollPadding,
      keyboardAppearance: widget.keyboardAppearance,
      enableInteractiveSelection: widget.enableInteractiveSelection,
      buildCounter: widget.buildCounter,
      mouseCursor: widget.mouseCursor,
      decoration: theme.decoration.merge(widget.decoration),
      cancelText: theme.cancelText,
      confirmText: theme.confirmText,
      errorFormatText: theme.errorFormatText,
      errorInvalidText: theme.errorInvalidText,
      fieldHintText: theme.fieldHintText,
      fieldLabelText: theme.fieldLabelText,
      helpText: theme.helpText,
      initialDate: widget.initialDate,
      initialValue: widget.initialDate,
      initialDatePickerMode: widget.initialDatePickerMode,
    );
  }
}
