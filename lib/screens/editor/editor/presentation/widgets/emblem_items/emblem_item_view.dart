import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/screens/editor/editor/presentation/cubits/boards/emblems/emblem_item.dart';
import 'package:flags/uikit/layout_components/containers/card.dart';
import 'package:flags/uikit/painters/drawable_painter.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flame/image_composition.dart';
import 'package:flutter/material.dart';

class EmblemItemView extends StatelessWidget {
  const EmblemItemView(
    this.item, {
    super.key,
  });

  final EmblemItem item;

  Widget buildView(BuildContext context) {
    return FCard(
      color: ThemePalette.blue.brighten(.5),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const Pad(all: 2),
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: DrawablePaint(
                  drawable: item.emblem,
                  size: item.emblem.image.size.toSize(),
                ),
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              item.emblem.name,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return buildView(context);
  }
}
