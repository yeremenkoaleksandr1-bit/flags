import 'package:flags/uikit/components/background/background.dart';
import 'package:flutter/material.dart';

class MainViewBuilder extends StatelessWidget {
  final Widget child;

  const MainViewBuilder({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.passthrough,
      children: [
        const Positioned.fill(
          child: Background(),
        ),
        Positioned.fill(
          child: child,
        ),
      ],
    );
  }
}
