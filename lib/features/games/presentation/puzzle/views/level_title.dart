import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flutter/material.dart';

class LevelTitleView extends StatelessWidget {
  const LevelTitleView({super.key, required this.levelName});

  final String levelName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const Pad(horizontal: 12),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: FText(
            levelName,
            textAlign: TextAlign.center,
            textStyle: const TextStyle(
              fontSize: 42,
            ),
          ),
        ),
      ),
    );
  }
}
