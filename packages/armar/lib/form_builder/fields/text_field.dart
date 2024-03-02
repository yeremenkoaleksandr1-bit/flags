import 'dart:ui' as ui;

import 'package:armar/armar.dart';
import 'package:armar/logger.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'form_field.dart';
import 'states/text_form_field.state.dart';
import 'themes/text_field.theme.dart';

abstract class ArTextField extends ArFormBuilderField<String> {
  ArTextField({
    super.key,
    required super.name,
    super.validator,
    super.initialValue,
    super.onChanged,
    super.valueTransformer,
    super.enabled,
    super.onSaved,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.onReset,
    super.focusNode,
    super.restorationId,
    this.errorBuilder,
    this.controller,
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
    this.cursorHeight,
    this.keyboardType,
    this.style,
    this.textInputAction,
    this.strutStyle,
    this.textDirection,
    this.maxLength,
    this.onEditingComplete,
    this.onSubmitted,
    this.inputFormatters,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.buildCounter,
    this.expands = false,
    this.minLines,
    this.showCursor,
    this.onTap,
    this.onTapOutside,
    this.enableSuggestions = false,
    this.textAlignVertical = TextAlignVertical.center,
    this.dragStartBehavior = DragStartBehavior.start,
    this.scrollController,
    this.scrollPhysics,
    this.selectionWidthStyle = ui.BoxWidthStyle.tight,
    this.smartDashesType,
    this.smartQuotesType,
    this.selectionHeightStyle = ui.BoxHeightStyle.tight,
    this.autofillHints,
    this.mouseCursor,
    this.contextMenuBuilder = _defaultContextMenuBuilder,
    this.magnifierConfiguration,
    this.contentInsertionConfiguration,
  }) : super(
          builder: (state) => Builder(builder: state.build),
        );

  final String obscuringCharacter;

  final TextEditingController? controller;

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

  final Widget Function(String errorBuilder)? errorBuilder;

  static Widget _defaultContextMenuBuilder(
    BuildContext context,
    EditableTextState editableTextState,
  ) {
    return AdaptiveTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }
}

class ArFormBuilderTextField extends ArTextField {
  ArFormBuilderTextField({
    super.key,
    required super.name,
    super.validator,
    super.initialValue,
    super.onChanged,
    super.valueTransformer,
    super.enabled,
    super.onSaved,
    super.autovalidateMode = AutovalidateMode.disabled,
    super.onReset,
    super.focusNode,
    super.restorationId,
    super.controller,
    super.obscuringCharacter = "*",
    super.readOnly = false,
    super.maxLines = 1,
    super.obscureText = false,
    super.textCapitalization = TextCapitalization.none,
    super.scrollPadding = const EdgeInsets.all(20.0),
    super.enableInteractiveSelection = true,
    super.maxLengthEnforcement,
    super.textAlign = TextAlign.start,
    super.autofocus = false,
    super.autocorrect = true,
    super.cursorWidth = 2.0,
    super.cursorHeight,
    super.keyboardType,
    super.style,
    super.textInputAction,
    super.strutStyle,
    super.textDirection,
    super.maxLength,
    super.onEditingComplete,
    super.onSubmitted,
    super.inputFormatters,
    super.cursorRadius,
    super.cursorColor,
    super.keyboardAppearance,
    super.buildCounter,
    super.expands = false,
    super.minLines,
    super.showCursor,
    super.onTap,
    super.onTapOutside,
    super.enableSuggestions,
    super.textAlignVertical,
    super.dragStartBehavior,
    super.scrollController,
    super.scrollPhysics,
    super.selectionWidthStyle,
    super.smartDashesType,
    super.smartQuotesType,
    super.selectionHeightStyle,
    super.autofillHints,
    super.mouseCursor,
    super.contextMenuBuilder,
    super.magnifierConfiguration,
    super.contentInsertionConfiguration,
    this.decoration,
  });

  final InputDecoration Function(BuildContext context)? decoration;

  @override
  ArFormBuilderFieldState<ArFormBuilderTextField, String> createState() =>
      ArFormBuilderTextFieldFieldState();
}

class ArFormBuilderTextFieldFieldState<T extends ArFormBuilderTextField>
    extends ArFormBuilderFieldState<T, String> {
  late final _theme =
      Theme.of(context).extension<ArFormBuilderTextFieldTheme>();

  TextEditingController? get _effectiveController =>
      widget.controller ?? _controller;

  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController(text: value);
    _controller!.addListener(_handleControllerChanged);
  }

  @override
  void dispose() {
    _controller!.removeListener(_handleControllerChanged);
    if (null == widget.controller) {
      _controller!.dispose();
    }

    super.dispose();
  }

  @override
  void reset() {
    super.reset();
    setState(() {
      _effectiveController!.text = initialValue ?? '';
    });
  }

  @override
  void didChange(String? value) {
    super.didChange(value);

    if (_effectiveController!.text != value) {
      _effectiveController!.text = value ?? '';
    }
  }

  void _handleControllerChanged() {
    if (_effectiveController!.text != (value ?? '')) {
      didChange(_effectiveController!.text);
    }
  }

  @override
  Widget build(BuildContext context) {

    return KeyedSubtree(
      key: ValueKey(errorText),
      child: ArTextFormField(
        name: widget.name,
        validator: FormBuilderValidators.compose([
          if (widget.validator != null) widget.validator!,
          if (errorText != null) (_) => errorText,
        ]),
        controller: _effectiveController,
        obscuringCharacter: widget.obscuringCharacter,
        errorBuilder: widget.errorBuilder,
        customErrorText: errorText,
        decoration: (_theme?.decoration ?? const InputDecoration())
            .merge(widget.decoration?.call(context)),
        onChanged: widget.onChanged,
        restorationId: restorationId,
        focusNode: effectiveFocusNode,
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
        obscureText: widget.obscureText,
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
        inputFormatters: widget.inputFormatters,
        enabled: enabled,
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
      ),
    );
  }
}
