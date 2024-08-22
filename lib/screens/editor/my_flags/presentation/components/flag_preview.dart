import 'package:flags/domain/editor/editor_flag.dart';
import 'package:flags/uikit/layout_components/containers/card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import 'editor_flag_item_drawer.dart';

class EditorFlagPreview extends StatelessWidget {
  const EditorFlagPreview({super.key, required this.flag});

  final EditorFlagData flag;

  @override
  Widget build(BuildContext context) {
    return FCard(
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: flag.proportion,
                child: FittedBox(
                  child: EditorFlagItemDrawer(flag: flag),
                ),
              ),
            ),
          ),
          Text(flag.name),
        ],
      ),
    );
  }
}
