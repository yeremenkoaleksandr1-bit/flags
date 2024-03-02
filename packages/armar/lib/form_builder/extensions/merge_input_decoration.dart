import 'package:flutter/material.dart';

extension MergeInputDecoration on InputDecoration {
  InputDecoration merge(InputDecoration? other) {
    if (other == null) return this;

    return InputDecoration(
      labelText: other.labelText ?? labelText,
      labelStyle: other.labelStyle ?? labelStyle,
      helperText: other.helperText ?? helperText,
      helperStyle: other.helperStyle ?? helperStyle,
      hintText: other.hintText ?? hintText,
      hintStyle: other.hintStyle ?? hintStyle,
      errorText: other.errorText ?? errorText,
      errorStyle: other.errorStyle ?? errorStyle,
      counterText: other.counterText ?? counterText,
      counterStyle: other.counterStyle ?? counterStyle,
      contentPadding: other.contentPadding ?? contentPadding,
      prefix: other.prefix ?? prefix,
      prefixIcon: other.prefixIcon ?? prefixIcon,
      suffix: other.suffix ?? suffix,
      suffixIcon: other.suffixIcon ?? suffixIcon,
      isCollapsed: other.isCollapsed ?? isCollapsed,
      isDense: other.isDense ?? isDense,
      enabled: other.enabled ?? enabled,
      filled: other.filled ?? filled,
      fillColor: other.fillColor ?? fillColor,
      focusColor: other.focusColor ?? focusColor,
      hoverColor: other.hoverColor ?? hoverColor,
      border: other.border ?? border,
      enabledBorder: other.enabledBorder ?? enabledBorder,
      errorBorder: other.errorBorder ?? errorBorder,
      focusedBorder: other.focusedBorder ?? focusedBorder,
      focusedErrorBorder: other.focusedErrorBorder ?? focusedErrorBorder,
      disabledBorder: other.disabledBorder ?? disabledBorder,
      alignLabelWithHint: other.alignLabelWithHint ?? alignLabelWithHint,
    );
  }
}
