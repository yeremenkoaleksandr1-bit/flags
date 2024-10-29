import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/ui/dialogs/dialogs.dart';
import 'package:flags/ui/game_scaffold.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/layout_components/containers/card.dart';
import 'package:flags/uikit/layout_components/gap/gap.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flutter/material.dart';

class SuccessfullImageSavedDialog extends DialogWidget {
  const SuccessfullImageSavedDialog({
    super.key,
  });

  @override
  Widget buildContainer(BuildContext context, Widget child) {
    return GamePageBuilder(
      startSlideDirection: GamePageSlideDirection.middle,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: FCard(
          padding: const Pad(all: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              FText(
                "The image was saved successfully!",
                textAlign: TextAlign.center,
              ),
              Gap.v4,
              const Text(
                "Check out your gallery",
                textAlign: TextAlign.center,
              ),
              Gap.v24,
              FGreenButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Center(
                  child: FText(
                    "Ok",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
