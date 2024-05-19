import 'package:flags/domain/game_objects/base/process.game_object.dart';
import 'package:flags/logger.dart';
import 'package:flags/presentation/game/puzzle/entities/board_item.dart';
import 'package:flags/presentation/game/puzzle/puzzle_common.presenter.dart';
import 'package:flags/uikit/game_widgets/game_widgets.dart';
import 'package:flutter/material.dart';

abstract class BoardItemWidget extends StatefulWidget {
  const BoardItemWidget({
    super.key,
    required this.item,
    required this.controller,
  });

  final BoardItem item;
  final IPuzzleCommonModePresenter controller;
}

abstract class BoardItemWidgetState<T extends BoardItemWidget>
    extends State<T> {
  late final ValueNotifier<BoardItem> modelRx = ValueNotifier(widget.item);

  BoardItem get model => modelRx.value;

  IPuzzleCommonModePresenter get presenter => widget.controller;

  ProcessGameObject get renderedObject => model.object;

  Widget buildWidget(
    BuildContext context,
    BoxConstraints constraints,
    BoardItem item,
  ) {
    return Material(
      color: Colors.transparent,
      child: GameObjectPaint(
        gameObject: renderedObject,
      ),
    );
  }

  @override
  void dispose() {
    modelRx.value;
    super.dispose();
  }

  @override
  @protected
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: modelRx,
      builder: (
        BuildContext context,
        BoardItem<ProcessGameObject> value,
        Widget? child,
      ) {
        Widget child = LayoutBuilder(
          builder: (context, constraints) => buildWidget(
            context,
            constraints,
            value,
          ),
        );

        if (model.build != null) {
          child = model.build!.call(child);
        }

        return ValueListenableBuilder(
          valueListenable: model.active,
          builder: (
            BuildContext context,
            bool value,
            Widget? _,
          ) {
            if (!value) {
              return const SizedBox.shrink();
            }

            return child;
          },
        );
      },
    );
  }
}
