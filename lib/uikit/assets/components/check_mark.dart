import 'package:flags/uikit/layout_components/sprite_widget.dart';

import '../assets.dart';

class UICheckMark extends SpriteUIWidget {
  UICheckMark({
    super.key,
    super.blendMode,
    super.color,
    super.filterQuality,
  }) : super(
          image: Assets.images.checkmark.image,
        );
}
