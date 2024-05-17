import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/domain/entities/game/game_levels/game_level.dart';
import 'package:flags/domain/game_objects/parts/path_part.dart';
import 'package:flags/presentation/game/puzzle/entities/board_item.dart';
import 'package:flags/presentation/game/puzzle/entities/colored_part.game_object.dart';
import 'package:flags/presentation/game/puzzle/onboarding/colored_part/colored_object.showcase_step_2.dart';
import 'package:flags/screens/games/puzzle/components/board_items/common_item.dart';
import 'package:flags/screens/games/puzzle/views/boards/base.dart';
import 'package:flags/uikit/components/buttons/actions/close_button.dart';
import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flags/uikit/utils/render_box_exposed.dart';
import 'package:flutter/material.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';

class ColoredPathEditingBoard extends ProcessObjectEditingBoard {
  const ColoredPathEditingBoard({
    super.key,
    required super.controller,
  });

  @override
  State<StatefulWidget> createState() => ColoredPathEditingBoardState();
}

class ColoredPathEditingBoardState
    extends ProcessObjectEditingBoardState<ColoredPathEditingBoard, BoardItem> {
  final RenderBoxExposer colorsListExposer = RenderBoxExposer();
  final ValueNotifier<Color?> colorRx = ValueNotifier(null);

  @override
  void initState() {
    activeRx.addListener(reset);
    super.initState();
  }

  Future<void> reset() async {
    final value = activeRx.value;

    if (value) {
      widget.controller.boardController.closeFullScreen();
      colorRx.value = Colors.grey;
    }
  }

  @override
  void dispose() {
    colorRx.dispose();
    super.dispose();
  }

  @override
  Widget buildWidget(BuildContext context, BoardItem? gameObject) {
    return PuzzleColoredObjectStep2Showcase(
      showcaseKey: widget.controller.showcase.coloredObjectStep2,
      colorsListExposer: colorsListExposer,
      onTap: () {
        widget.controller.showcase.showcaseState.next();
        widget.controller.showcase.complete("puzzle_colored_object_2");
      },
      child: Builder(
        builder: (context) {
          if (gameObject == null) {
            return const SizedBox.shrink();
          }

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
                        widget.controller.unfocusObject();
                      },
                    ),
                  ),
                  Gap.v24,
                  Expanded(
                    child: MultiValueListenableBuilder(
                      valueListenables: [
                        colorRx,
                        widget.controller.state.level
                      ],
                      builder: (
                        BuildContext context,
                        List<dynamic> values,
                        Widget? child,
                      ) {
                        final Color? color = values[0];
                        final GameLevel level = values[1];

                        var object = gameObject.object as PathGameObject;

                        object = object.copyWith(
                          path: object.path.copyWith(
                            paint: object.path.paint.copyWith(
                              color: color ?? Colors.grey,
                            ),
                          ),
                        );

                        return BoardCommonItemWidget(
                          key: ValueKey(color),
                          controller: widget.controller,
                          item: gameObject.copyWith(
                            object: object,
                          ),
                          flag: level.flag,
                        );
                      },
                    ),
                  ),
                  Gap.v48,
                  Center(
                    child: RenderBoxExposed(
                      exposer: colorsListExposer,
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
                  ),
                  Gap.custom(height: 48),
                ],
              );
            },
          );
        },
      ),
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
          side: const BorderSide(),
        ),
        child: const SizedBox.square(
          dimension: 48,
        ),
      ),
    );
  }
}
