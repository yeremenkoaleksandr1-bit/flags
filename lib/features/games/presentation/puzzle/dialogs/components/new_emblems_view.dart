import 'package:flags/domain/game_objects/emblems/emblem.gameObject.dart';
import 'package:flags/uikit/game_widgets/game_widgets.dart';
import 'package:flags/uikit/layout_components/containers/card.dart';
import 'package:flags/uikit/theme/borders.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class PuzzleNewEmblemView extends StatelessWidget {
  const PuzzleNewEmblemView({
    super.key,
    required this.emblems,
  });

  final List<EmblemPart> emblems;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisSpacing: 4,
      mainAxisSpacing: 4,
      crossAxisCount: 3,
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        ...emblems.map(
          (e) => CupertinoButton(
            padding: EdgeInsets.zero,
            alignment: Alignment.topLeft,
            onPressed: () async {
              await showDialog(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return Center(
                        child: SizedBox.square(
                          dimension: constraints.maxWidth / 1.2,
                          child: Material(
                            color: ThemePalette.white.withValues(alpha: 0.3),
                            shape: ThemeBorders.small,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GameObjectPaint(
                                gameObject: e,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }, minimumSize: Size(0, 0),
            child: ClipRRect(
              child: Banner(
                color: ThemePalette.blue,
                message: 'new',
                location: BannerLocation.topStart,
                child: FCard(
                  child: SizedBox.expand(
                    child: GameObjectPaint(
                      gameObject: e,
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
