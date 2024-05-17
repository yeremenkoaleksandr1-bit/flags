import 'package:flutter/widgets.dart';
import 'package:state_manager/state_manager.dart';

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
  late final ValueNotifier<bool> shownRx = ValueNotifier(widget.initialShown);

  void onShow() {}

  void onHide() {}

  @override
  void initState() {
    Get.put<I>(this as I, tag: widget.tag);
    super.initState();
  }

  @override
  void dispose() {
    Get.delete<I>(tag: widget.tag);
    shownRx.dispose();
    super.dispose();
  }

  Widget buildChild(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: ValueListenableBuilder(
        valueListenable: shownRx,
        builder: (BuildContext context, bool value, Widget? child) {
          return IgnorePointer(
            ignoring: !value,
            child: AnimatedOpacity(
              opacity: value ? 1 : 0,
              duration: const Duration(milliseconds: 150),
              child: child,
            ),
          );
        },
        child: buildChild(context),
      ),
    );
  }

  @override
  Future<void> show() async {
    shownRx.value = true;
    onShow();
  }

  @override
  Future<void> hide() async {
    shownRx.value = false;
    onHide();
  }

  @override
  bool get isShown => shownRx.value;
}
