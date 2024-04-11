import 'package:defer_pointer/defer_pointer.dart';
import 'package:flutter/material.dart';

class EOHandleButton extends StatelessWidget {
  const EOHandleButton({
    super.key,
    required this.child,
    required this.onDrag,
  });

  final Widget child;
  final void Function() onDrag;

  @override
  Widget build(BuildContext context) {
    return DeferPointer(
      child: Material(
        shape: const RoundedRectangleBorder(side: BorderSide()),
        child: SizedBox.square(
          dimension: 24,
          child: Center(child: child),
        ),
      ),
    );
  }
}
