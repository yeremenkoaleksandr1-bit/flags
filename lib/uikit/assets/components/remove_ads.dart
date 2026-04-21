import 'package:flags/uikit/assets/assets.dart';
import 'package:flags/uikit/layout_components/sprite_widget.dart';

class RemoveAdsImage extends SpriteUIWidget {
  RemoveAdsImage({
    super.key,
    super.blendMode,
    super.color,
    super.filterQuality,
  }) : super(
          image: Assets.images.removeAds.image,
        );
}
