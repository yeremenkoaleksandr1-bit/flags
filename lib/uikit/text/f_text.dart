import 'package:flags/uikit/text/stroke_text.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flags/uikit/theme/text.dart';
import 'package:flutter/material.dart';

class FText extends StrokeText {
  FText(
    super.text, {
    super.key,
    super.strokeColor = ThemePalette.black,
    super.strokeWidth = 6,
    super.textColor = ThemePalette.white,
    super.textAlign,
    TextStyle? textStyle,
  }) : super(
          textStyle: const TextStyle(
            fontSize: FontSizes.body,
          ).merge(textStyle),
        );
}
