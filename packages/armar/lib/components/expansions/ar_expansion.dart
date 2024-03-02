import 'package:flutter/material.dart';

import '../../armar.dart';
import '../cross_fade/cross_fade.dart';

class ArExpansionPanel extends StatefulWidget {
  const ArExpansionPanel({
    super.key,
    required this.title,
    required this.content,
    this.initiallyActivity = false,
    this.activeGesture = true,
  });

  final Widget Function(bool active) title;
  final Widget content;

  final bool initiallyActivity;

  final bool activeGesture;

  @override
  State<ArExpansionPanel> createState() => _ArExpansionPanelState();
}

class _ArExpansionPanelState extends State<ArExpansionPanel> {
  late final RxBool _active = widget.initiallyActivity.rx;

  void toggleActive() {
    _active.value = !_active.value;
  }

  @override
  void didUpdateWidget(covariant ArExpansionPanel oldWidget) {
    if (oldWidget.initiallyActivity != widget.initiallyActivity) {
      _active.value = widget.initiallyActivity;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: FastBuilder(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            InkWell(
              onTap: widget.activeGesture ? toggleActive : null,
              child: widget.title(_active.value),
            ),
            ArCrossFade(
              active: _active.value,
              child: widget.content,
            ),
          ],
        );
      }),
    );
  }
}
