import 'package:flags/uikit/text/f_text.dart';
import 'package:flutter/widgets.dart';

class ContinentTitleView extends StatelessWidget {
  const ContinentTitleView({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: FText(
          title,
          textAlign: TextAlign.start,
          strokeWidth: 12,
          textStyle: const TextStyle(fontSize: 58),
        ),
      ),
    );
  }
}
