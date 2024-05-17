import 'package:flags/core/extensions/render_box.dart';
import 'package:flags/presentation/game/puzzle/puzzle_common.presenter.dart';
import 'package:flags/uikit/layout_components/containers/card.dart';
import 'package:flutter/widgets.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';

abstract class ProcessObjectEditingBoard extends StatefulWidget {
  const ProcessObjectEditingBoard({
    super.key,
    required this.controller,
  });

  final IPuzzleCommonModePresenter controller;
}

abstract class ProcessObjectEditingBoardState<
    T extends ProcessObjectEditingBoard, G> extends State<T> {
  final ValueNotifier<G?> _currentObject = ValueNotifier(null);

  final ValueNotifier<bool> activeRx = ValueNotifier(false);

  void show() {
    activeRx.value = true;
  }

  void hide() {
    activeRx.value = false;
  }

  @override
  void dispose() {
    _currentObject.dispose();
    activeRx.dispose();

    super.dispose();
  }

  @override
  void initState() {
    activeRx.addListener(activeRxListenerFunc);
    widget.controller.focusedObject.addListener(() {
      final value = widget.controller.focusedObject.value;

      activeRx.value = value != null && value is G;
    });
    super.initState();
  }

  void activeRxListenerFunc() {
    final value = activeRx.value;

    if (value) {
      _currentObject.value = widget.controller.focusedObject.value;
    }
  }

  Widget buildWidget(BuildContext context, G? gameObject);

  Duration get duration => const Duration(milliseconds: 100);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final presenter = widget.controller;

    return MultiValueListenableBuilder(
      valueListenables: [
        presenter.flagExposer.renderBox,
        activeRx,
        _currentObject,
      ],
      builder: (
        BuildContext context,
        List<dynamic> values,
        Widget? child,
      ) {
        double top;
        final RenderBox? flagRenderBox = values[0];

        if (flagRenderBox != null && !flagRenderBox.attached) {
          return const SizedBox.shrink();
        }

        final rect = flagRenderBox?.getRect() ?? Offset.zero & Size.zero;

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
