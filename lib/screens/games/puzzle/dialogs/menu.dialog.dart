import 'package:flags/ui/dialogs/dialogs.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/cupertino.dart';

class PuzzleMenuDialog extends DialogWidget {
  const PuzzleMenuDialog({
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
            "Menu",
            textStyle: const TextStyle(fontSize: 58),
          ),
        ),
        Gap.v24,
        FYellowButton(
          onPressed: onRestart,
          child: Center(
            child: FText("restart"),
          ),
        ),
        Gap.v24,
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
