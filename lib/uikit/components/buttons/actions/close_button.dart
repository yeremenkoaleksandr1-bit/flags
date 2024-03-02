import 'package:flags/uikit/assets/assets.dart';
import 'package:flags/uikit/components/buttons/actions/base.dart';
import 'package:flags/uikit/layout_components/containers/card.dart';
import 'package:flags/uikit/layout_components/sprite_widget.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flutter/cupertino.dart';

class FCloseButton extends FActionButton {
  const FCloseButton({
    super.key,
    super.onTap,
    super.duration,
  });

  @override
  Widget buildWidget(BuildContext context) {
    return FCard(
      color: ThemePalette.red,
      child: SizedBox.square(
        dimension: 24,
        child: SpriteUIWidget(
          image: Assets.images.cross.image,
        ),
      ),
    );
  }
}
