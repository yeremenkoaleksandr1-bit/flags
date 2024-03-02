import 'package:armar/armar.dart';
import 'package:flutter/widgets.dart';

class ArTextBodyMedium extends ArText {
  const ArTextBodyMedium(
    super.data, {
    super.key,
    super.style,
    super.textAlign,
    super.textDirection,
    super.locale,
    super.softWrap,
    super.overflow,
    super.textScaleFactor,
    super.maxLines,
    super.semanticsLabel,
    super.textWidthBasis,
    super.textHeightBehavior,
  });

  @override
  TextStyle? buildStyle(BuildContext context) => context.textTheme.bodyMedium;
}
