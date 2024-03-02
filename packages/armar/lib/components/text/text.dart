import 'package:flutter/material.dart';

import '../../logger.dart';

class ArText extends StatelessWidget implements Text {
  const ArText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow = TextOverflow.ellipsis,
    this.textScaleFactor,
    this.maxLines = 20,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
    this.strutStyle,
    this.textSpan,
    this.textScaler,
  });

  @override
  final String data;

  @override
  final TextStyle? style;
  @override
  final TextAlign? textAlign;
  @override
  final TextDirection? textDirection;
  @override
  final Locale? locale;
  @override
  final bool? softWrap;
  @override
  final TextOverflow? overflow;
  @override
  final double? textScaleFactor;
  @override
  final int? maxLines;
  @override
  final String? semanticsLabel;
  @override
  final TextWidthBasis? textWidthBasis;
  @override
  final TextHeightBehavior? textHeightBehavior;

  @override
  final Color? selectionColor;

  @override
  final StrutStyle? strutStyle;

  @override
  final InlineSpan? textSpan;

  @override
  final TextScaler? textScaler;

  TextStyle? buildStyle(BuildContext context) => const TextStyle();

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);


    final superStyle = buildStyle(context);

    final def = defaultTextStyle.style.copyWith(
      fontFamily: superStyle?.fontFamily,
      fontSize: superStyle?.fontSize,
    );

    TextStyle? effectiveTextStyle = superStyle;

    if (MediaQuery.boldTextOf(context)) {
      effectiveTextStyle = effectiveTextStyle!.merge(
        const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      );
    }

    return RichText(
      text: textSpan ??
          TextSpan(
            text: data,
            style: effectiveTextStyle?.merge(def).merge(style),
          ),
      locale: locale,
      textAlign: textAlign ?? defaultTextStyle.textAlign ?? TextAlign.start,
      textDirection: textDirection,
      softWrap: softWrap ?? defaultTextStyle.softWrap,
      overflow:
          overflow ?? effectiveTextStyle?.overflow ?? defaultTextStyle.overflow,
      maxLines: maxLines ?? defaultTextStyle.maxLines,
      strutStyle: strutStyle,
      textWidthBasis: textWidthBasis ?? defaultTextStyle.textWidthBasis,
      textHeightBehavior: textHeightBehavior ??
          defaultTextStyle.textHeightBehavior ??
          DefaultTextHeightBehavior.maybeOf(context),
      selectionColor: selectionColor ??
          DefaultSelectionStyle.of(context).selectionColor ??
          DefaultSelectionStyle.defaultColor,
    );
  }
}
