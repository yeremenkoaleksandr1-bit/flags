import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/domain/game_objects/flag/flag.dart';
import 'package:flags/domain/interfaces/drawable/i_drawable.dart';
import 'package:flags/uikit/game_widgets/flag/flag.dart';
import 'package:flags/uikit/layout_components/assets/assets.dart';
import 'package:flags/uikit/layout_components/sprite_widget.dart';
import 'package:flags/uikit/painters/drawable_painter.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flags/uikit/theme/indents.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';

import '../../../core/elements/paint.dart';
import '../../../domain/entities/path/path.dart';
import '../../../domain/game_objects/parts/path_part.dart';
import '../../../uikit/assets/assets.dart';

class PuzzleModeView extends StatefulWidget {
  const PuzzleModeView({super.key});

  @override
  State<PuzzleModeView> createState() => _PuzzleModeViewState();
}

class _PuzzleModeViewState extends State<PuzzleModeView> {
  final GameFlag flag = GameFlag(
    name: "puzzle_mode",
    proportion: 2 / 3,
    objects: (size) {
      return [
        PathPart(
          name: '1',
          path: SPath.rect(
            rect: Vector2(19.4, size.y).toRect(),
            paint: SPaint(
              style: PaintingStyle.fill,
              color: const Color(0xFFFF3131),
            ),
          ),
        ),
        PathPart(
          name: "2",
          position: Vector2(19.4, 0),
          path: SPath.rect(
            rect: Vector2(57.21, size.y).toRect(),
            paint: SPaint(
              style: PaintingStyle.fill,
              color: const Color(0xFFFFFFFF),
            ),
          ),
        ),
        PathPart(
          name: '1',
          position: Vector2(76.6, 0),
          path: SPath.rect(
            rect: Vector2(19.4, size.y).toRect(),
            paint: SPaint(
              style: PaintingStyle.fill,
              color: const Color(0xFFFF3131),
            ),
          ),
        ),
        PathPart.fromSvgPath(
          "M31.598 19 .402 37.011V.99L31.598 19Z",
          name: "name",
          areaSize: size,
          color: const Color(0xffFF3131),
        ),
      ];
    },
  );

  late final IDrawable itemInHand = flag.objects.removeLast();

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
                          child: Padding(
                            padding: const Pad(all: 9, top: 24, bottom: 12),
                            child: FlagView(
                              flag: flag,
                            ),
                          ),
                        ),
                        Positioned(
                          top: constraints.maxHeight - 60,
                          left: constraints.maxWidth - 140,
                          width: 64,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                top: -24,
                                left: -24,
                                child: Transform.scale(
                                  scale: 2,
                                  child: DrawablePaint(drawable: itemInHand),
                                ),
                              ),
                              Transform.rotate(
                                angle: radians(-24),
                                child: Center(
                                  child: SpriteUIWidget(
                                    image: Assets.images.hand.image,
                                  ),
                                ),
                              ),
                            ],
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
