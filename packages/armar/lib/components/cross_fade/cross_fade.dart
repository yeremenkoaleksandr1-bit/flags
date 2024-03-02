import 'package:flutter/material.dart';

class ArCrossFade extends StatelessWidget {
  const ArCrossFade({
    super.key,
    required this.active,
    required this.child,
    this.hidedChild = const SizedBox(
      height: 0,
      width: double.infinity,
    ),
    this.duration = const Duration(milliseconds: 250),
  });

  final bool active;

  final Widget child;
  final Widget hidedChild;

  final Duration duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: duration,
      firstChild: hidedChild,
      secondChild: child,
      firstCurve: const Interval(
        0.0,
        0.6,
        curve: Curves.fastOutSlowIn,
      ),
      secondCurve: const Interval(
        0.4,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
      sizeCurve: Curves.fastOutSlowIn,
      crossFadeState:
          active ? CrossFadeState.showSecond : CrossFadeState.showFirst,
    );
  }
}
