import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flutter/material.dart';

class GameModeComingSoon extends StatelessWidget {
  const GameModeComingSoon({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const Pad(horizontal: 24),
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: FText("Coming soon..."),
      ),
    );
  }
}
