import 'package:armar/armar.dart';
import 'package:drag_and_drop/extensions/render_box.dart';
import 'package:flags/presentation/game/puzzle/puzzle_common.presenter.dart';
import 'package:flutter/widgets.dart';

import '../../../../../uikit/layout_components/containers/card.dart';

abstract class ProcessObjectEditingBoard extends StatefulWidget {
  const ProcessObjectEditingBoard({
    super.key,
    required this.presenter,
  });

  final IPuzzleCommonModePresenter presenter;
}

abstract class ProcessObjectEditingBoardState<
    T extends ProcessObjectEditingBoard, G> extends State<T> {
  final RxValue<G?> _currentObject = RxValue(null);

  final RxValue<bool> activeRx = RxValue(false);

  void show() {
    activeRx.value = true;
  }

  void hide() {
    activeRx.value = false;
  }

  @override
  void initState() {
    activeRx.stream.listen((event) {
      if (event) {
        _currentObject.value = widget.presenter.focusedObject.value;
      }
    });
    widget.presenter.focusedObject.stream.listen((event) {
      activeRx.value = event != null && event is G;
    });
    super.initState();
  }

  Widget buildWidget(BuildContext context, G? gameObject);

  Duration get duration => const Duration(milliseconds: 100);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final presenter = widget.presenter;

    return FastBuilder(
      () {
        double top;
        final flagRenderBox = presenter.flagExposer.renderBox.value;
        if (flagRenderBox != null && !flagRenderBox.attached) {
          return const SizedBox.shrink();
        }

        final rect = flagRenderBox?.rect ?? Offset.zero & Size.zero;

        if (activeRx.value) {
          top = rect.bottom + 24;
        } else {
          top = mq.size.height + mq.padding.bottom;
        }

        return AnimatedPositioned(
          duration: duration,
          onEnd: () {
            if (!activeRx.value) {
              _currentObject.value = null;
            }
          },
          left: 0,
          right: 0,
          top: top,
          height: mq.size.height - rect.bottom,
          child: FCard(
            child: buildWidget(
              context,
              _currentObject.value,
            ),
          ),
        );
      },
    );
  }
}
