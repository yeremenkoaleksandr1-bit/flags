import 'package:flags/uikit/layout_components/sprite_widget.dart';

import '../assets.dart';

class UIClose extends SpriteUIWidget {
  UIClose({
    super.key,
    super.blendMode,
    super.color,
    super.filterQuality,
  }) : super(
          image: Assets.images.cross.image,
        );
}
