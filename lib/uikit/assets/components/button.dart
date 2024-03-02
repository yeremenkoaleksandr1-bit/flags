import 'package:flags/uikit/assets/assets.dart';

import '../../layout_components/nine_slice_widget.dart';

class AButtonWidget extends NineSliceWidget {
  AButtonWidget({
    super.child,
    super.color,
    super.blendMode,
    super.filterQuality,
    super.key,
  }) : super(
          image: Assets.images.greyButton.image,
          left: 24,
          top: 19,
          right: 24,
          bottom: 28,
        );
}
