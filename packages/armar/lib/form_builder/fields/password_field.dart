import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../armar.dart';

class ArFormBuilderPasswordField extends StatefulWidget {
  const ArFormBuilderPasswordField({
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
    this.keyboardType,
    this.textInputAction,
    this.style,
    this.strutStyle,
    this.textAlignVertical,
    this.textDirection,
    this.smartDashesType,
    this.smartQuotesType,
    this.minLines,
    this.contextMenuBuilder,
    this.showCursor,
    this.maxLength,
    this.onEditingComplete,
    this.onSubmitted,
    this.inputFormatters,
    this.cursorHeight,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.onTap,
    this.onTapOutside,
    this.mouseCursor,
    this.buildCounter,
    this.scrollPhysics,
    this.scrollController,
    this.autofillHints,
    this.magnifierConfiguration,
    this.contentInsertionConfiguration,
    this.obscuringCharacter = "*",
    this.readOnly = false,
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
    this.enableSuggestions = false,
    this.expands = false,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.dragStartBehavior = DragStartBehavior.start,
  });

  final String name;

  final InputDecoration Function(bool isObscured)? decoration;
  final FormFieldSetter<String>? onSaved;

  final FormFieldValidator<String>? validator;

  final String? initialValue;

  final bool enabled;

  final AutovalidateMode autovalidateMode;

  final String? restorationId;

  final IconData? showedPasswordIcon;
  final IconData? hiddenPasswordIcon;

  final ValueTransformer<String?>? valueTransformer;

  final ValueChanged<String?>? onChanged;

  final VoidCallback? onReset;

  final FocusNode? focusNode;

  final String obscuringCharacter;

  final TextEditingController? controller;
  final List<String>? errors;

  final TextInputType? keyboardType;

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

  final SmartDashesType? smartDashesType;

  final SmartQuotesType? smartQuotesType;

  final bool enableSuggestions;
  final int? maxLines;

  final int? minLines;

  final bool expands;

  final EditableTextContextMenuBuilder? contextMenuBuilder;

  final bool? showCursor;

  static const int noMaxLength = -1;

  final int? maxLength;

  final MaxLengthEnforcement? maxLengthEnforcement;

  final VoidCallback? onEditingComplete;

  final ValueChanged<String?>? onSubmitted;

  final List<TextInputFormatter>? inputFormatters;

  final double cursorWidth;

  final double? cursorHeight;

  final Radius? cursorRadius;

  final ui.Color? cursorColor;

  final ui.BoxHeightStyle selectionHeightStyle;

  final ui.BoxWidthStyle selectionWidthStyle;

  final Brightness? keyboardAppearance;

  final EdgeInsets scrollPadding;

  final bool enableInteractiveSelection;

  final DragStartBehavior dragStartBehavior;

  bool get selectionEnabled => enableInteractiveSelection;

  final GestureTapCallback? onTap;

  final TapRegionCallback? onTapOutside;

  final MouseCursor? mouseCursor;

  final InputCounterWidgetBuilder? buildCounter;

  final ScrollPhysics? scrollPhysics;

  final ScrollController? scrollController;

  final Iterable<String>? autofillHints;

  final TextMagnifierConfiguration? magnifierConfiguration;

  final bool readOnly;

  final ContentInsertionConfiguration? contentInsertionConfiguration;

  @override
  ArPasswordFieldState createState() => ArPasswordFieldState();
}

class ArPasswordFieldState extends State<ArFormBuilderPasswordField> {
  final RxBool isObscured = true.rx;

  void _toggleObscure() {
    isObscured.value = !isObscured.value;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<ArPasswordFieldTheme>() ??
        const ArPasswordFieldTheme();

    return FastBuilder(() {
      return ArFormBuilderTextField(
        name: widget.name,
        obscuringCharacter: "*",
        obscureText: isObscured.value,
        validator: widget.validator,
        controller: widget.controller,
        onChanged: widget.onChanged,
        restorationId: widget.restorationId,
        focusNode: widget.focusNode,
        keyboardType: widget.keyboardType,
        textInputAction: widget.textInputAction,
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
        readOnly: widget.readOnly,
        showCursor: widget.showCursor,
        autocorrect: widget.autocorrect,
        enableSuggestions: widget.enableSuggestions,
        maxLengthEnforcement: widget.maxLengthEnforcement,
        maxLines: widget.maxLines,
        minLines: widget.minLines,
        expands: widget.expands,
        maxLength: widget.maxLength,
        onTap: widget.onTap,
        onTapOutside: widget.onTapOutside,
        onEditingComplete: widget.onEditingComplete,
        onSubmitted: widget.onSubmitted,
        inputFormatters: widget.inputFormatters,
        cursorWidth: widget.cursorWidth,
        cursorHeight: widget.cursorHeight,
        cursorRadius: widget.cursorRadius,
        cursorColor: widget.cursorColor,
        scrollPadding: widget.scrollPadding,
        keyboardAppearance: widget.keyboardAppearance,
        enableInteractiveSelection: widget.enableInteractiveSelection,
        buildCounter: widget.buildCounter,
        dragStartBehavior: widget.dragStartBehavior,
        scrollController: widget.scrollController,
        scrollPhysics: widget.scrollPhysics,
        selectionHeightStyle: widget.selectionHeightStyle,
        selectionWidthStyle: widget.selectionWidthStyle,
        smartDashesType: widget.smartDashesType,
        smartQuotesType: widget.smartQuotesType,
        mouseCursor: widget.mouseCursor,
        contextMenuBuilder: widget.contextMenuBuilder,
        autofillHints: widget.autofillHints,
        magnifierConfiguration: widget.magnifierConfiguration,
        contentInsertionConfiguration: widget.contentInsertionConfiguration,
        decoration: (_) => InputDecoration(
          suffixIcon: IconButton(
            onPressed: _toggleObscure,
            icon: Icon(
              isObscured.value
                  ? widget.hiddenPasswordIcon ?? theme.hiddenPasswordIcon
                  : widget.showedPasswordIcon ?? theme.showedPasswordIcon,
              size: theme.iconSize,
              color: theme.iconColor,
            ),
          ),
        ).merge(
          widget.decoration?.call(
            isObscured.value,
          ),
        ),
      );
    });
  }
}
