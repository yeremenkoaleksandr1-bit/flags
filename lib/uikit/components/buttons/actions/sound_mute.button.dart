import 'package:flags/features/audio/audio.provider.dart';
import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flags/uikit/theme/theme.dart';
import 'package:flutter/cupertino.dart';

class FSoundMuteButton extends StatelessWidget {
  const FSoundMuteButton({super.key});

  @override
  Widget build(BuildContext context) {
    final audioService = AudioProvider.of(context);

    return FBlueButton(
      onPressed: audioService.toggleMute,
      child: ValueListenableBuilder(
        valueListenable: audioService.muted,
        builder: (BuildContext context, bool value, Widget? child) {
          return Icon(
            value ? CupertinoIcons.volume_off : CupertinoIcons.volume_up,
            color: ThemePalette.white,
          );
        },
      ),
    );
  }
}
