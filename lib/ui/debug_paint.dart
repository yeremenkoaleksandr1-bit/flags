// ignore_for_file: invalid_use_of_protected_member

import 'dart:ui';

import 'package:flags/core/flutter_engine.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

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
  static bool _initialized = false;

  static late final DebugPainter _instance;

  static void paint(void Function(Canvas canvas, Size size) callback) {
    FlutterEngine.widgetPostFrameCallback((timeStamp) {
      _instance.paintFunc(callback);
    });
  }

  static void drawVectors(
    List<Vector2> vectors, {
    PointMode pointMode = PointMode.lines,
    Paint? paint,
  }) {
    DebugPainter.paint(
      (canvas, size) {
        canvas.drawPoints(
          pointMode,
          [...vectors.map((e) => e.toOffset())],
          paint ?? Paint()
            ..color = Colors.red
            ..strokeWidth = 4,
        );
      },
    );
  }

  void paintFunc(void Function(Canvas canvas, Size size) callback);
}

class _DebugPaintProviderState extends State<DebugPaintProvider>
    implements DebugPainter {
  final Set<Function(Canvas canvas, Size size)> _queue = {};

  @override
  void initState() {
    if (!DebugPainter._initialized) {
      DebugPainter._instance = this;
      DebugPainter._initialized = true;
    }

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
        RepaintBoundary(
          child: widget.builder(context),
        ),
        RepaintBoundary(
          child: Positioned.fill(
            child: IgnorePointer(
              child: Material(
                type: MaterialType.transparency,
                child: CustomPaint(
                  willChange: true,
                  foregroundPainter: _Painter(
                    _queue,
                    onPaintCompleted: _queue.clear,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void paintFunc(void Function(Canvas canvas, Size size) callback) {
    // WidgetsBinding.instance.drawFrame();
    setState(() {
      _queue.add(callback);
    });
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
