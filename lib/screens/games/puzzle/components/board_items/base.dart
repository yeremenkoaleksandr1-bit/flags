import 'package:armar/armar.dart';
import 'package:flags/domain/game_objects/base/process.game_object.dart';
import 'package:flags/presentation/game/puzzle/puzzle_common.presenter.dart';
import 'package:flutter/material.dart';

import '../../../../../presentation/game/puzzle/entities/board_item.dart';
import '../../../../../uikit/game_widgets/game_widgets.dart';

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
    return RepaintBoundary(
      child: FastBuilder(() {
        final active = model.active.value;

        if (!active) return const SizedBox.shrink();

        return LayoutBuilder(
          builder: buildWidget,
        );
      }),
    );
  }
}
