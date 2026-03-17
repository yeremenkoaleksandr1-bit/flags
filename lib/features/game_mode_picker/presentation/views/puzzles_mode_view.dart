import 'package:flags/core/elements/paint.dart';
import 'package:flags/domain/entities/path/path.dart';
import 'package:flags/domain/game_objects/flag/flag.dart';
import 'package:flags/domain/game_objects/parts/path_part.dart';
import 'package:flags/domain/interfaces/drawable/i_drawable.dart';
import 'package:flags/uikit/assets/assets.dart';
import 'package:flags/uikit/game_widgets/flag/flag.dart';
import 'package:flags/uikit/layout_components/containers/card.dart';
import 'package:flags/uikit/layout_components/sprite_widget.dart';
import 'package:flags/uikit/painters/drawable_painter.dart';
import 'package:flags/uikit/text/f_text.dart';
import 'package:flags/uikit/theme/indents.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        PathGameObject(
          name: '1',
          path: SPath.rect(
            rect: Vector2(19.4, size.y).toRect(),
            paint: SPaint(
              style: PaintingStyle.fill,
              color: const Color(0xFFFF3131),
            ),
          ),
        ),
        PathGameObject(
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
        PathGameObject(
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
        PathGameObject.fromSvgPath(
          "M62 36 .5 71.507V.493L62 36Z",
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
      padding: EdgeInsets.all(ThemeIndents.s24),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          Align(
            alignment: Alignment.center,
            child: AspectRatio(
              aspectRatio: 1.6 / 1,
              child: FCard(
                padding: EdgeInsets.zero,
                color: ThemePalette.gentleYellow,
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Stack(
                      clipBehavior: Clip.none,
                      fit: StackFit.passthrough,
                      children: [
                        Positioned(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(9.w, 24.h, 9.w, 12.h),
                            child: FlagView(flag: flag),
                          ),
                        ),
                        Positioned(
                          top: constraints.maxHeight - 60.h,
                          left: constraints.maxWidth - 140.w,
                          width: 64.w,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Positioned(
                                top: -24.h,
                                left: -24.w,
                                width: 64.w,
                                height: 64.h,
                                child: DrawablePaint(drawable: itemInHand),
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
                          top: -52.h,
                          left: 0,
                          right: 48.w,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: FText(
                              "Puzzles",
                              strokeWidth: 18.r,
                              strokeColor: ThemePalette.gentleYellow,
                              textStyle: TextStyle(
                                color: ThemePalette.gentleYellow.darken(0.25),
                                fontSize: 64.sp,
                              ),
                            ),
                          ),
                        ),
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
