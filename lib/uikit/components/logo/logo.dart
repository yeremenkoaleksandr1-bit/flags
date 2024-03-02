import 'package:flutter/material.dart';

import '../../uikit.dart';

class FLogoTextView extends StatelessWidget {
  const FLogoTextView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FText(
          "Flags",
          strokeWidth: 12,
          textStyle: const TextStyle(
            fontSize: 64,
            color: ThemePalette.white,
          ),
        ),
        FText(
          "Up",
          strokeWidth: 12,
          textStyle: const TextStyle(
            fontSize: 84,
            color: ThemePalette.yellow,
            height: -0.15,
          ),
        ),
      ],
    );
  }
}
