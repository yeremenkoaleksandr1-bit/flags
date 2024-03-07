import 'package:flags/core/flutter_engine.dart';
import 'package:flutter/material.dart';

class Overlayment extends StatefulWidget {
  const Overlayment({super.key, required this.child});

  final Widget child;

  static OverlaymentState? of<T>(BuildContext context) {
    return context.findAncestorStateOfType<OverlaymentState>();
  }

  @override
  State<Overlayment> createState() => OverlaymentState();
}

class OverlaymentState extends State<Overlayment> {
  final List<OverlayEntry> _overlays = [];

  void insert(OverlayEntry entry) {
    _overlays.add(entry);
    Overlay.of(context).insert(entry);
  }

  void closeAllOverlays() {
    for (var overlay in _overlays) {
      FlutterEngine.widgetPostFrameCallback((timeStamp) {
        overlay.remove();
      });
    }
  }

  void remove(OverlayEntry entry) {
    _overlays.remove(entry);
    entry.remove();
  }

  @override
  void dispose() {
    closeAllOverlays();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ScaffoldMessenger(
        child: widget.child,
      );
}
