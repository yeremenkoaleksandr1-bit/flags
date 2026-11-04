import 'package:flags/uikit/shaders/stroke_text_shader.dart';
import 'package:flutter/material.dart';

class StrokeText extends StatelessWidget {
  const StrokeText(
    this.text, {
    super.key,
    this.strokeWidth = 1,
    this.strokeColor = Colors.black,
    this.textColor = Colors.white,
    this.textShader,
    this.strokeShader,
    this.textStyle,
    this.textAlign,
    this.maxLines,
  });

  final String text;
  final double strokeWidth;
  final Color textColor;
  final Color strokeColor;
  final ShaderCallback? textShader;
  final ShaderCallback? strokeShader;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final resolvedTextAlign = textAlign ?? TextAlign.start;
    final baseStyle = DefaultTextStyle.of(context).style.merge(textStyle);

    return CustomPaint(
      foregroundPainter: _StrokeTextPainter(
        text: text,
        strokeWidth: strokeWidth,
        strokeColor: strokeColor,
        textColor: textColor,
        textShader: textShader,
        strokeShader: strokeShader,
        textStyle: baseStyle,
        textAlign: resolvedTextAlign,
        textDirection: Directionality.of(context),
        maxLines: maxLines,
      ),
      child: Text(
        text,
        textAlign: resolvedTextAlign,
        maxLines: maxLines,
        overflow: TextOverflow.visible,
        style: baseStyle.copyWith(color: Colors.transparent),
      ),
    );
  }
}

class _StrokeTextPainter extends CustomPainter {
  const _StrokeTextPainter({
    required this.text,
    required this.strokeWidth,
    required this.strokeColor,
    required this.textColor,
    required this.textShader,
    required this.strokeShader,
    required this.textStyle,
    required this.textAlign,
    required this.textDirection,
    required this.maxLines,
  });

  final String text;
  final double strokeWidth;
  final Color strokeColor;
  final Color textColor;
  final ShaderCallback? textShader;
  final ShaderCallback? strokeShader;
  final TextStyle textStyle;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final int? maxLines;

  @override
  void paint(Canvas canvas, Size size) {
    final shaderBounds = Offset.zero & size;

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..strokeWidth = strokeWidth;

    if (strokeShader case final shader?) {
      strokePaint.shader = shader(shaderBounds);
    } else {
      final shader = StrokeTextShader.create(
        bounds: shaderBounds,
        color: strokeColor,
      );
      if (shader != null) {
        strokePaint.shader = shader;
      } else {
        strokePaint.color = strokeColor;
      }
    }

    final fillPaint = Paint();
    if (textShader case final shader?) {
      fillPaint.shader = shader(shaderBounds);
    } else {
      fillPaint.color = textColor;
    }

    final strokePainter = _createTextPainter(
      style: textStyle.copyWith(foreground: strokePaint),
      maxWidth: size.width,
    );
    strokePainter.paint(canvas, Offset.zero);

    final fillPainter = _createTextPainter(
      style: textStyle.copyWith(foreground: fillPaint),
      maxWidth: size.width,
    );
    fillPainter.paint(canvas, Offset.zero);
  }

  TextPainter _createTextPainter({
    required TextStyle style,
    required double maxWidth,
  }) {
    return TextPainter(
      text: TextSpan(text: text, style: style),
      textAlign: textAlign,
      textDirection: textDirection,
      maxLines: maxLines,
    )..layout(maxWidth: maxWidth.isFinite ? maxWidth : double.infinity);
  }

  @override
  bool shouldRepaint(covariant _StrokeTextPainter oldDelegate) {
    return text != oldDelegate.text ||
        strokeWidth != oldDelegate.strokeWidth ||
        strokeColor != oldDelegate.strokeColor ||
        textColor != oldDelegate.textColor ||
        textShader != oldDelegate.textShader ||
        strokeShader != oldDelegate.strokeShader ||
        textStyle != oldDelegate.textStyle ||
        textAlign != oldDelegate.textAlign ||
        textDirection != oldDelegate.textDirection ||
        maxLines != oldDelegate.maxLines;
  }
}
