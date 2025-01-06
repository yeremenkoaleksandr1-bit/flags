import 'package:flags/ui/dialogs/dialogs.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/cupertino.dart';

class PuzzleLoseDialog extends DialogWidget {
  const PuzzleLoseDialog({
    super.key,
    required this.onRestart,
    required this.onExit,
  });

  final VoidCallback onRestart;
  final VoidCallback onExit;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: FText(
            "game over",
            textStyle: const TextStyle(fontSize: 58),
          ),
        ),
        FYellowButton(
          onPressed: onRestart,
          child: Center(
            child: FText("restart"),
          ),
        ),
        Gap.v4,
        FRedButton(
          onPressed: onExit,
          child: Center(
            child: FText("exit"),
          ),
        ),
      ],
    );
  }
}
