import 'package:armar/armar.dart';
import 'package:armar/logger.dart';
import 'package:flags/domain/game_objects/base/process.game_object.dart';
import 'package:flags/presentation/game/puzzle/entities/board_item.dart';
import 'package:flags/presentation/game/puzzle/puzzle_common.presenter.dart';
import 'package:flags/uikit/game_widgets/game_widgets.dart';
import 'package:flutter/material.dart';

abstract class BoardItemWidget extends StatefulWidget {
  const BoardItemWidget({
    super.key,
    required this.item,
    required this.presenter,
  });

  final BoardItem item;
  final IPuzzleCommonModePresenter presenter;
}

abstract class BoardItemWidgetState<T extends BoardItemWidget>
    extends State<T> {
  final GlobalKey _widgetKey = GlobalKey();

  BoardItem get model => widget.item;

  IPuzzleCommonModePresenter get presenter => widget.presenter;

  ProcessGameObject get renderedObject => model.object;

  Widget buildWidget(BuildContext context, BoxConstraints constraints) {
    return Material(
      color: Colors.transparent,
      child: GameObjectPaint(
        key: _widgetKey,
        gameObject: renderedObject,
      ),
    );
  }

  @override
  @protected
  Widget build(BuildContext context) {
    Widget child = LayoutBuilder(
      builder: buildWidget,
    );

    if (model.build != null) {
      child = model.build!.call(child);
    }

    return RepaintBoundary(
      child: FastBuilder(() {
        final active = model.active.value;
        i++;

        if (!active) {
          return const SizedBox.shrink();
        }

        return child;
      }),
    );
  }
}

int i = 0;
