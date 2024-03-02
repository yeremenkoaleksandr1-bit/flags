import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/uikit/layout_components/assets/assets.dart';
import 'package:flags/uikit/layout_components/sprite_widget.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flags/uikit/theme/indents.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

import '../../../uikit/assets/assets.dart';

class PuzzleModeView extends StatelessWidget {
  const PuzzleModeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const Pad(all: ThemeIndents.s24),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Align(
            alignment: Alignment.center,
            child: AspectRatio(
              aspectRatio: 1.6 / 1,
              child: NineCardView(
                color: ThemePalette.gentleYellow,
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Stack(
                      clipBehavior: Clip.none,
                      fit: StackFit.passthrough,
                      children: [
                        Positioned(
                          top: constraints.maxHeight - 60,
                          left: constraints.maxWidth - 120,
                          width: 64,
                          child: Transform.rotate(
                            angle: radians(-24),
                            child: Center(
                              child: SpriteUIWidget(
                                image: Assets.images.hand.image,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: -52,
                          left: 0,
                          right: 48,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: FText(
                              "Puzzles",
                              strokeWidth: 18,
                              strokeColor: ThemePalette.gentleYellow,
                              textStyle: TextStyle(
                                color: ThemePalette.gentleYellow.darken(0.5),
                                fontSize: 64,
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
