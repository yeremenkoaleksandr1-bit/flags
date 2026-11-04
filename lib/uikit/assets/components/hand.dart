import 'package:flags/uikit/assets/assets.dart';
import 'package:flags/uikit/layout_components/sprite_widget.dart';

class UIHand extends SpriteUIWidget {
  UIHand({
    super.key,
    super.blendMode,
    super.color,
    super.filterQuality,
  }) : super(
          image: Assets.images.hand.image,
        );
}
