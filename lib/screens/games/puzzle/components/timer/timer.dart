import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/uikit/assets/assets.dart';
import 'package:flags/uikit/layout_components/sprite_widget.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/widgets.dart';

import 'package:flags/uikit/uikit.dart';

class FastModeTimer extends StatefulWidget {
  const FastModeTimer({
    super.key,
    required this.timerStream,
  });

  final Stream<int> timerStream;

  @override
  State<FastModeTimer> createState() => _FastModeTimerState();
}

class _FastModeTimerState extends State<FastModeTimer> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale: 1.4,
          child: SpriteUIWidget(image: Assets.images.timer.image),
        ),
        Gap.h14,
        StreamBuilder(
          stream: widget.timerStream,
          builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
            return FText(
              (snapshot.data ?? "--").toString(),
            );
          },
        ),
      ],
    );
  }
}
