import 'package:flags/uikit/layout_components/nine_slice_widget.dart';

import '../../../assets/assets.dart';

class NineCardView extends NineSliceWidget {
  NineCardView({
    super.key,
    required super.child,
    super.color,
    super.blendMode,
    super.filterQuality,
  }) : super(
          left: 8,
          top: 8,
          right: 8,
          bottom: 8,
          image: Assets.images.panel.image,
        );
}
