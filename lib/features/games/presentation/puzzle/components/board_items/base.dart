import 'package:flags/domain/game_objects/base/process.game_object.dart';
import 'package:flags/presentation/game/puzzle/entities/board_item.dart';
import 'package:flags/presentation/game/puzzle/puzzle_common.presenter.dart';
import 'package:flags/uikit/game_widgets/game_widgets.dart';
import 'package:flutter/material.dart';

abstract class BoardItemWidget extends StatefulWidget {
  const BoardItemWidget({
    super.key,
    required this.item,
    required this.cubit,
  });

  final BoardItem item;
  final PuzzleCommonModeCubit cubit;
}

abstract class BoardItemWidgetState<T extends BoardItemWidget>
    extends State<T> {
  BoardItem get model => widget.item;

  PuzzleCommonModeCubit get cubit => widget.cubit;

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
  @protected
  Widget build(BuildContext context) {
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

        return LayoutBuilder(
          builder: (context, constraints) => buildWidget(
            context,
            constraints,
            model,
          ),
        );
      },
    );
  }
}
