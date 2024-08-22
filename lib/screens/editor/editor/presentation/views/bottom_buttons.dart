import 'package:flags/uikit/components/buttons/buttons.dart';
import 'package:flutter/cupertino.dart';

class EditorBottomButtonsView extends StatelessWidget {
  const EditorBottomButtonsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FGreenButton(
            onPressed: () {},
            child: const AspectRatio(
              aspectRatio: 1,
              child: Center(child: Text("styles")),
            ),
          ),
        ),
        Expanded(
          child: FGreenButton(
            onPressed: () {},
            child: const AspectRatio(
              aspectRatio: 1,
              child: Center(child: Text("shapes")),
            ),
          ),
        ),
        Expanded(
          child: FGreenButton(
            onPressed: () {},
            child: const AspectRatio(
              aspectRatio: 1,
              child: Center(child: Text("emblems")),
            ),
          ),
        ),
        Expanded(
          child: FGreenButton(
            onPressed: () {},
            child: const AspectRatio(
              aspectRatio: 1,
              child: Center(child: Text("custom")),
            ),
          ),
        ),
      ],
    );
  }
}
