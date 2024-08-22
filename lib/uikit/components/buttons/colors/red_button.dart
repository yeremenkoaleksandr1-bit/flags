import 'package:flags/uikit/theme/palette.dart';

import '../button.dart';

class FRedButton extends FButton {
  const FRedButton({
    super.key,
    required super.onPressed,
    required super.child,
    super.padding,
  }) : super(
          color: ThemePalette.red,
        );
}
