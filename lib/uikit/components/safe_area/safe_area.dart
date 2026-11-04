import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flutter/cupertino.dart';

class GameSafeArea extends StatelessWidget {
  const GameSafeArea({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);

    var top = mq.padding.top;

    if (top == 0.0) {
      top = 24.0;
    }

    return Padding(
      padding: Pad(top: top),
      child: child,
    );
  }
}
