
import 'package:drag_and_drop/extensions/render_box.dart';
import 'package:flutter/cupertino.dart';

mixin OverlayStateMixin<T extends StatefulWidget> on State<T> {
  OverlayEntry? _entry;

  bool get _isOverlayShown => _entry != null;

  void showOverlay() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final renderBox = context.findRenderObject()!;

      _insertOverlay(renderBox.paintBounds);
    });
  }

  void toggleOverlay() {
    if (!_isOverlayShown) {
      showOverlay();
    } else {
      removeOverlay();
    }
  }

  void _insertOverlay(Rect rect) {
    _entry = OverlayEntry(
      maintainState: true,
      builder: (context) => Positioned(
        key: UniqueKey(),
        top: rect.top,
        left: rect.left,
        width: rect.width,
        height: rect.height,
        child: buildOverlay(context, rect),
      ),
    );

    Overlay.of(context).insert(_entry!);
  }

  void removeOverlay() {
    _entry?.remove();
    _entry = null;
  }

  @override
  void didChangeDependencies() {
    removeOverlay();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    removeOverlay();
    super.dispose();
  }

  Widget buildOverlay(BuildContext context, Rect rect);
}
