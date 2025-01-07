import 'package:flags/ui/dialogs/dialogs.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class PuzzleMenuDialog extends DialogWidget {
  const PuzzleMenuDialog({
    super.key,
    required this.onRestart,
    required this.onExit,
    required this.seed,
  });

  final void Function(BuildContext context) onRestart;
  final void Function(BuildContext context) onExit;

  final int seed;

  @override
  Widget buildContainer(BuildContext context, Widget child) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: CupertinoButton(
            onPressed: () {
              Clipboard.setData(
                ClipboardData(
                  text: seed.toString(),
                ),
              );
            },
            child: FText(
              "$seed",
              textStyle: const TextStyle(
                fontFamily: "Troika",
              ),
            ),
          ),
        ),
        Align(
          child: super.buildContainer(context, child),
        ),
      ],
    );
  }

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
          onPressed: () => onRestart(context),
          child: Center(
            child: FText("restart"),
          ),
        ),
        Gap.v24,
        FRedButton(
          onPressed: () => onExit(context),
          child: Center(
            child: FText("exit"),
          ),
        ),
      ],
    );
  }
}
