import 'package:flutter/material.dart';

class StrokeText extends StatelessWidget {
  final String text;
  final double strokeWidth;
  final Color textColor;
  final Color strokeColor;
  final TextStyle? textStyle;
  final TextAlign? textAlign;

  const StrokeText(
    this.text, {
    super.key,
    this.strokeWidth = 1,
    this.strokeColor = Colors.black,
    this.textColor = Colors.white,
    this.textStyle,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Text(
          text,
          textAlign: textAlign,
          overflow: TextOverflow.visible,
          style: TextStyle(
            foreground: Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = strokeWidth
              ..color = strokeColor,
          ).merge(textStyle),
        ),
        Text(
          text,
          textAlign: textAlign,
          overflow: TextOverflow.visible,
          style: TextStyle(color: textColor).merge(textStyle),
        ),
      ],
    );
  }
}
