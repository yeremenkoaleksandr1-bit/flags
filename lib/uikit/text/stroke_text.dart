import 'package:flags/uikit/shaders/stroke_text_shader.dart';
import 'package:flutter/material.dart';

class StrokeText extends StatelessWidget {
  final String text;
  final double strokeWidth;
  final Color textColor;
  final Color strokeColor;
  final ShaderCallback? textShader;
  final ShaderCallback? strokeShader;
  final TextStyle? textStyle;
  final TextAlign? textAlign;
  final int? maxLines;

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

  @override
  Widget build(BuildContext context) {
    final resolvedTextAlign = textAlign ?? TextAlign.start;
    final baseStyle = DefaultTextStyle.of(context).style.merge(textStyle);

    return LayoutBuilder(
      builder: (context, constraints) {
        final textPainter = TextPainter(
          text: TextSpan(text: text, style: baseStyle),
          textAlign: resolvedTextAlign,
          textDirection: Directionality.of(context),
          maxLines: maxLines,
        )..layout(
          maxWidth: constraints.hasBoundedWidth
              ? constraints.maxWidth
              : double.infinity,
        );

        final shaderBounds = Offset.zero & textPainter.size;

        final strokePaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..strokeWidth = strokeWidth;

        if (strokeShader case final shader?) {
          strokePaint.shader = shader(shaderBounds);
        } else {
          strokePaint.shader = StrokeTextShader.create(
            bounds: shaderBounds,
            color: strokeColor,
          );
        }

        final fillPaint = Paint();
        if (textShader case final shader?) {
          fillPaint.shader = shader(shaderBounds);
        } else {
          fillPaint.color = textColor;
        }

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Text(
              text,
              textAlign: resolvedTextAlign,
              overflow: TextOverflow.visible,
              maxLines: maxLines,
              style: baseStyle.copyWith(foreground: strokePaint),
            ),
            Text(
              text,
              textAlign: resolvedTextAlign,
              overflow: TextOverflow.visible,
              maxLines: maxLines,
              style: baseStyle.copyWith(foreground: fillPaint),
            ),
          ],
        );
      },
    );
  }
}
