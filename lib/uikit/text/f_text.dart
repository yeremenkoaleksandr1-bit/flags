import 'package:flags/uikit/text/stroke_text.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flags/uikit/theme/text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FText extends StrokeText {
  FText(
    super.text, {
    super.key,
    super.strokeColor = ThemePalette.black,
    double strokeWidth = 6,
    super.textColor = ThemePalette.white,
    super.textAlign,
    super.maxLines,
    TextStyle? textStyle,
  }) : super(
         strokeWidth: strokeWidth.r,
         textStyle: TextStyle(fontSize: FontSizes.body).merge(textStyle),
       );
}
