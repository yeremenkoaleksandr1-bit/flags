import 'package:armar/armar.dart';
import 'package:armar/logger.dart';
import 'package:armar/rx/rx.dart';
import 'package:flutter/widgets.dart';

abstract class UiLayer extends StatefulWidget {
  const UiLayer({
    super.key,
    required this.tag,
    this.initialShown = true,
  });

  final bool initialShown;

  final String tag;
}

abstract interface class IUiLayer {
  static IUiLayer find(String tag) => Get.find(tag: tag);

  Future<void> show();

  Future<void> hide();

  bool get isShown;
}

abstract class UiLayerState<T extends UiLayer, I extends IUiLayer>
    extends State<T> implements IUiLayer {
  late final RxValue<bool> shownRx = RxValue(widget.initialShown);

  @override
  void initState() {
    Get.put<I>(this as I, tag: widget.tag);
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<I>(tag: widget.tag);
    super.dispose();
  }

  Widget buildChild(BuildContext context);

  @override
  Widget build(BuildContext context) {
    final child = buildChild(context);

    return Positioned(
      child: FastValueBuilder(
        listen: shownRx,
        builder: (bool value) {
          return IgnorePointer(
            ignoring: !value,
            child: AnimatedOpacity(
              opacity: value ? 1 : 0,
              duration: const Duration(milliseconds: 150),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Future<void> show() async {
    shownRx.value = true;
  }

  @override
  Future<void> hide() async {
    shownRx.value = false;
  }

  @override
  bool get isShown => shownRx.value;
}
