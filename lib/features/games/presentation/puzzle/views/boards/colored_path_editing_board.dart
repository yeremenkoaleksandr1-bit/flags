import 'package:bloc_utils/bloc_utils.dart';
import 'package:flags/domain/game_objects/game_objects.dart';
import 'package:flags/features/games/presentation/puzzle/components/board_items/common_item.dart';
import 'package:flags/features/games/presentation/puzzle/views/boards/base.dart';
import 'package:flags/presentation/game/puzzle/entities/board_item.dart';
import 'package:flags/presentation/game/puzzle/entities/colored_part.game_object.dart';
import 'package:flags/presentation/game/puzzle/onboarding/colored_part/colored_object.showcase_step_2.dart';
import 'package:flags/uikit/components/buttons/actions/close_button.dart';
import 'package:flags/uikit/components/gestures/scaled_gesture.dart';
import 'package:flags/uikit/uikit.dart';
import 'package:flags/uikit/utils/render_box_exposed.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ColoredPathEditingBoard extends ProcessObjectEditingBoard {
  const ColoredPathEditingBoard({
    super.key,
    required super.cubit,
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
      widget.cubit.boardController.closeFullScreen();
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
      showcaseKey: widget.cubit.showcase.coloredObjectStep2,
      colorsListExposer: colorsListExposer,
      onTap: () {
        widget.cubit.showcase.showcaseState.next();
        widget.cubit.showcase.complete("puzzle_colored_object_2");
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
                        widget.cubit.unfocusObject();
                      },
                    ),
                  ),
                  Gap.v12,
                  Expanded(

                    child: BlocDynamicStateBuilder(
                      bloc: widget.cubit,
                      builder: (BuildContext context, state) {
                        return ValueListenableBuilder(
                          valueListenable: colorRx,
                          builder: (
                            BuildContext context,
                            Color? value,
                            Widget? child,
                          ) {
                            var object = gameObject.object as PathGameObject;

                            object = object.copyWith(
                              path: object.path.copyWith(
                                paint: object.path.paint.copyWith(
                                  color: value ?? Colors.grey,
                                ),
                              ),
                            );

                            return BoardCommonItemWidget(
                              cubit: widget.cubit,
                              item: gameObject.copyWith(
                                object: object,
                              ),
                              flag: state.level.flag,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  Gap.v18,
                  Center(
                    child: RenderBoxExposed(
                      exposer: colorsListExposer,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          spacing: 12.w,
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
