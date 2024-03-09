import 'package:armar/armar.dart';
import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/domain/game_objects/game_objects.dart';
import 'package:flags/presentation/game/puzzle/entities/board_item.dart';
import 'package:flags/presentation/game/puzzle/entities/colored_part.game_object.dart';
import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../uikit/components/buttons/actions/close_button.dart';
import '../../../../../uikit/uikit.dart';
import '../../components/board_items/common_item.dart';
import 'base.dart';

class ColoredPathEditingBoard extends ProcessObjectEditingBoard {
  const ColoredPathEditingBoard({
    super.key,
    required super.presenter,
  });

  @override
  State<StatefulWidget> createState() => ColoredPathEditingBoardState();
}

class ColoredPathEditingBoardState
    extends ProcessObjectEditingBoardState<ColoredPathEditingBoard, BoardItem> {
  final RxValue<Color?> colorRx = RxValue(null);

  @override
  void initState() {
    activeRx.stream.listen((event) {
      if (event) {
        widget.presenter.boardController.closeFullScreen();
        colorRx.value = Colors.grey;
      }
    });
    super.initState();
  }

  @override
  Widget buildWidget(BuildContext context, BoardItem? gameObject) {
    if (gameObject == null) return const SizedBox.shrink();

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final objectInstance = gameObject.object as ColoredPart;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: FCloseButton(
                onTap: () {
                  widget.presenter.unfocusObject();
                },
              ),
            ),
            Gap.v24,
            Expanded(
              child: FastBuilder(
                () {
                  final color = colorRx.value;

                  var object = (gameObject.object as PathPart);

                  object = object.copyWith(
                    path: object.path.copyWith(
                      paint: object.path.paint.copyWith(
                        color: color ?? Colors.grey,
                      ),
                    ),
                  );

                  return BoardCommonItemWidget(
                    key: ValueKey(color),
                    presenter: widget.presenter,
                    item: gameObject.copyWith(
                      object: object,
                    ),
                    flag: widget.presenter.state.level.value.flag,
                  );
                },
              ),
            ),
            Gap.v48,
            Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: RowSuper(
                  innerDistance: 12,
                  children: [
                    ...objectInstance.colors.map(
                      (e) => _ColorButton(
                        color: e,
                        onSelected: (Color value) {
                          colorRx.value = value;
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Gap.custom(height: 48),
          ],
        );
      },
    );
  }
}

class _ColorButton extends StatelessWidget {
  const _ColorButton({
    super.key,
    required this.color,
    required this.onSelected,
  });

  final Color color;
  final ValueChanged<Color> onSelected;

  @override
  Widget build(BuildContext context) {
    return ScaledGestureDetector(
      onTap: () => onSelected(color),
      child: Material(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: ThemePalette.black),
        ),
        child: const SizedBox.square(
          dimension: 48,
        ),
      ),
    );
  }
}
