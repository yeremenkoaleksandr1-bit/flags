import 'dart:async';

import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flutter/material.dart';

class FBackButton extends StatefulWidget {
  const FBackButton({
    super.key,
    this.onPressed,
  });

  final FutureOr<void> Function()? onPressed;

  @override
  State<FBackButton> createState() => _FBackButtonState();
}

class _FBackButtonState extends State<FBackButton> {
  Future<void> _onPressed() async {
    if (widget.onPressed != null) {
      await widget.onPressed?.call();
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return FRedButton(
      padding: EdgeInsets.zero,
      onPressed: _onPressed,
      child: SizedBox.square(
        dimension: 48,
        child: Transform.translate(
          offset: const Offset(0, -2),
          child: const Icon(
            Icons.chevron_left,
            color: ThemePalette.white,
            size: 46,
          ),
        ),
      ),
    );
  }
}
