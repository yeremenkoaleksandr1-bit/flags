import 'package:flutter/material.dart';

import '../../../../../uikit/text/f_text.dart';

class AnimatedSecondsTimer extends StatefulWidget {
  const AnimatedSecondsTimer({
    super.key,
    required this.timerStream,
  });

  final Stream<int> timerStream;

  @override
  State<AnimatedSecondsTimer> createState() => _AnimatedSecondsTimerState();
}

class _AnimatedSecondsTimerState extends State<AnimatedSecondsTimer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.timerStream,
      initialData: 99,
      builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
        return FText(
          snapshot.data.toString(),
          textStyle: const TextStyle(
            fontSize: 128,
          ),
        );
      },
    );
  }
}
