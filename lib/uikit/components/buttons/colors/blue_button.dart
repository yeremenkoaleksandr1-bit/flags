import 'package:flags/uikit/theme/palette.dart';

import '../button.dart';

class FBlueButton extends FButton {
  const FBlueButton({
    super.key,
    required super.onPressed,
    required super.child,
  }) : super(
          color: ThemePalette.blue,
        );
}
