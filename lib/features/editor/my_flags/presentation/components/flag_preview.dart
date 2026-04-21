import 'package:flags/domain/editor/editor_flag.dart';
import 'package:flags/domain/game_objects/base/process.game_object.dart';
import 'package:flags/domain/game_objects/game_objects.dart';
import 'package:flags/uikit/layout_components/containers/card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

import 'editor_flag_item_drawer.dart';

class EditorFlagPreview extends StatefulWidget {
  const EditorFlagPreview({super.key, required this.flag});

  final EditorFlagData flag;

  @override
  State<EditorFlagPreview> createState() => _EditorFlagPreviewState();
}

class _EditorFlagPreviewState extends State<EditorFlagPreview> {
  late final flag = widget.flag;

  @override
  void initState() {
    for (final e in flag.objects.whereType<ImageGameObject>()) {
      e.init().then((_) {
        setState(() {});
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FCard(
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: AspectRatio(
                aspectRatio: widget.flag.proportion,
                child: FittedBox(
                  child: EditorFlagItemDrawer(flag: widget.flag),
                ),
              ),
            ),
          ),
          Text(widget.flag.name, maxLines: 2),
        ],
      ),
    );
  }
}
