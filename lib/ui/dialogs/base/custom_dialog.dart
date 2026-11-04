import 'package:flags/uikit/layout_components/containers/card.dart';
import 'package:flutter/material.dart';

import '../../../uikit/theme/paddings.dart';

class FCustomDialog extends StatelessWidget {
  const FCustomDialog({
    super.key,
    required this.child,
    required this.dialogContext,
    this.alignment = Alignment.center,
  });

  final Alignment alignment;
  final BuildContext dialogContext;
  final Widget child;

  void closeDialog() {
    Navigator.of(dialogContext).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: ThemePaddings.screen,
          child: Align(
            alignment: alignment,
            child: FCard(
              child: child,
            ),
          ),
        ),
      ],
    );
  }
}
