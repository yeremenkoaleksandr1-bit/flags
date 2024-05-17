// ignore_for_file: invalid_use_of_protected_member

import 'package:flags/core/flutter_engine.dart';
import 'package:flutter/material.dart';
import 'package:state_manager/state_manager.dart';

class DebugPaintProvider extends StatefulWidget {
  const DebugPaintProvider({
    super.key,
    required this.builder,
  });

  final WidgetBuilder builder;

  @override
  State<DebugPaintProvider> createState() => _DebugPaintProviderState();
}

abstract class DebugPainter {
  static late final DebugPainter _instance;

  static void paint(void Function(Canvas canvas, Size size) callback) {
    FlutterEngine.widgetPostFrameCallback((timeStamp) {
      _instance.paintFunc(callback);
    });
  }

  void paintFunc(void Function(Canvas canvas, Size size) callback);
}

class _DebugPaintProviderState extends State<DebugPaintProvider>
    implements DebugPainter {
  final ValueNotifierSet<Function(Canvas canvas, Size size)> _queue =
      ValueNotifierSet();

  @override
  void initState() {
    DebugPainter._instance = this;
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.builder(context),
        Positioned.fill(
          child: IgnorePointer(
            child: Material(
              type: MaterialType.transparency,
              child: ValueListenableBuilder(
                valueListenable: _queue,
                builder: (
                  BuildContext context,
                  Set<dynamic Function(Canvas, Size)> value,
                  Widget? child,
                ) {
                  return CustomPaint(
                    foregroundPainter: _Painter(
                      value,
                      onPaintCompleted: _queue.clear,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void paintFunc(void Function(Canvas canvas, Size size) callback) {
    _queue.add(callback);
  }
}

class _Painter extends CustomPainter {
  final Iterable<dynamic Function(Canvas, Size)> queue;

  _Painter(
    this.queue, {
    required this.onPaintCompleted,
  });

  final VoidCallback onPaintCompleted;

  @override
  void paint(Canvas canvas, Size size) {
    for (final paint in queue) {
      paint(canvas, size);
    }

    onPaintCompleted();
  }

  @override
  bool shouldRepaint(covariant _Painter oldDelegate) {
    return oldDelegate.queue != queue && queue.isNotEmpty;
  }
}
