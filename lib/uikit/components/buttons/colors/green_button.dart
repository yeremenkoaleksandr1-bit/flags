import 'package:flags/uikit/theme/palette.dart';

import '../button.dart';

class FGreenButton extends FButton {
  const FGreenButton({
    super.key,
    required super.onPressed,
    required super.child,
  }) : super(
          color: ThemePalette.green,
        );
}
