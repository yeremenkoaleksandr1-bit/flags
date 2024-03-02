import 'dart:async';

import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:qlevar_router/qlevar_router.dart';

import '../../../assets/components/button.dart';

class FBackButton extends StatelessWidget {
  const FBackButton({
    super.key,
    this.onPressed,
  });

  final FutureOr<void> Function()? onPressed;

  void _onPressed() async {
    if (onPressed != null) {
      await onPressed?.call();
      return;
    }

    QR.back();
  }

  @override
  Widget build(BuildContext context) {
    return ScaledGestureDetector(
      onTap: _onPressed,
      child: AButtonWidget(
        color: ThemePalette.red,
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
      ),
    );
  }
}
