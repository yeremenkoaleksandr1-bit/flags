import 'package:flags/uikit/theme/palette.dart';

import '../button.dart';

class FYellowButton extends FButton {
  const FYellowButton({
    super.key,
    required super.onPressed,
    required super.child,
  }) : super(
          color: ThemePalette.yellow,
        );
}
