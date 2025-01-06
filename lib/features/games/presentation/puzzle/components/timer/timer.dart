import 'package:flags/uikit/assets/assets.dart';
import 'package:flags/uikit/layout_components/sprite_widget.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class FastModeTimer extends StatefulWidget {
  const FastModeTimer({
    super.key,
    required this.timerStream,
  });

  final ValueListenable<int> timerStream;

  @override
  State<FastModeTimer> createState() => _FastModeTimerState();
}

class _FastModeTimerState extends State<FastModeTimer> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale: 1.2,
          child: SpriteUIWidget(image: Assets.images.timer.image),
        ),
        Gap.h14,
        ValueListenableBuilder(
          valueListenable: widget.timerStream,
          builder: (
            BuildContext context,
            int value,
            Widget? child,
          ) {
            return FText(
              "$value",
            );
          },
        ),
      ],
    );
  }
}
