import 'package:flags/uikit/components/buttons/button.dart';
import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flutter/material.dart';

import 'package:flags/uikit/assets/components/button.dart';

class OpenMenuButton extends StatelessWidget {
  const OpenMenuButton({
    super.key,
    required this.onPressed,
  });

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return FButton(
      padding: EdgeInsets.zero,
      color: ThemePalette.orange,
      onPressed: onPressed,
      child: SizedBox.square(
        dimension: 48,
        child: Transform.translate(
          offset: const Offset(0, -2),
          child: const Icon(
            Icons.menu,
            color: ThemePalette.white,
            size: 32,
          ),
        ),
      ),
    );
  }
}
