import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:flags/domain/game_objects/base/process.game_object.dart';
import 'package:flags/presentation/game/puzzle/entities/colored_part.game_object.dart';
import 'package:flags/presentation/game/puzzle/puzzle_fast.presenter.dart';
import 'package:flags/screens/games/puzzle/components/board_items/base.dart';
import 'package:flags/uikit/layout_components/containers/card.dart';
import 'package:flags/uikit/theme/palette.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BoardColoredPartWidget extends BoardItemWidget {
  const BoardColoredPartWidget({
    super.key,
    required super.controller,
    required super.item,
  });

  @override
  State<BoardColoredPartWidget> createState() => BoardColoredPartWidgetState();
}

class BoardColoredPartWidgetState
    extends BoardItemWidgetState<BoardColoredPartWidget> {
  final OverlayPortalController _controller = OverlayPortalController();
  final _link = LayerLink();

  void _longPressHandler(LongPressGestureRecognizer i) {
    i.onLongPress = _controller.show;
    i.onLongPressEnd = (e) => _controller.hide();
    i.onLongPressCancel = _controller.hide;
  }

  Future<void> onTap() async {
    presenter.setFocusOnObject(model);

    if (presenter is! IPuzzleFastModePresenter) {
      await Future.delayed(const Duration(milliseconds: 101));
      presenter.showcase.show(
        [presenter.showcase.coloredObjectStep2],
        "puzzle_colored_object_2",
      );
    }
  }

  @override
  ProcessGameObject get renderedObject {
    final object = super.renderedObject as ColoredPart;
    return object.copyWith(
      path: object.path.copyWith(
        paint: object.path.paint.copyWith(
          color: Colors.grey,
        ),
      ),
    );
  }

  @override
  Widget buildWidget(BuildContext context, BoxConstraints constraints) {
    final object = model.object as ColoredPart;

    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _controller,
        overlayChildBuilder: (BuildContext context) {
          return CompositedTransformFollower(
            link: _link,
            offset: const Offset(-8, -32),
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: SizedBox(
                width: _link.leaderSize!.width + 16,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: RowSuper(
                    mainAxisSize: MainAxisSize.min,
                    innerDistance: 2,
                    children: [
                      ...object.colors.map(
                        (e) => DecoratedBox(
                          decoration: ShapeDecoration(
                            color: e,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: const BorderSide(color: ThemePalette.black),
                            ),
                          ),
                          child: const SizedBox.square(
                            dimension: 24,
                          ),
                        ),
                      )
                    ],
                  ),
                ).animate().boxShadow(
                      duration: const Duration(milliseconds: 10),
                    ),
              ),
            ),
          );
        },
        child: RawGestureDetector(
          gestures: {
            TapGestureRecognizer:
                GestureRecognizerFactoryWithHandlers<TapGestureRecognizer>(
              () => TapGestureRecognizer(),
              (i) => i.onTap = onTap,
            ),
            LongPressGestureRecognizer: GestureRecognizerFactoryWithHandlers<
                LongPressGestureRecognizer>(
              () => LongPressGestureRecognizer(
                duration: const Duration(milliseconds: 150),
              ),
              _longPressHandler,
            ),
          },
          child: Material(
            color: ThemePalette.transparent,
            child: Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.none,
              children: [
                Positioned.fill(
                  child: super.buildWidget(context, constraints),
                ),
                const Positioned(
                  bottom: -8,
                  right: -8,
                  child: IgnorePointer(
                    child: FCard(
                      padding: Pad(all: 2),
                      child: Icon(
                        Icons.palette,
                        color: ThemePalette.black,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
