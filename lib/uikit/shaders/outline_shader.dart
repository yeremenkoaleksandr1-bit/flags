import 'dart:ui' as ui;

import 'package:flags/uikit/shaders/shaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class OutlineShader extends StatefulWidget {
  const OutlineShader({
    super.key,
    required this.child,
    this.color = Colors.white,
    this.strokeWidth = 2,
  });

  final Widget child;
  final Color color;
  final double strokeWidth;

  @override
  State<OutlineShader> createState() => _OutlineShaderState();
}

class _OutlineShaderState extends State<OutlineShader> {
  final GlobalKey _boundaryKey = GlobalKey();

  ui.Image? _snapshot;
  Size? _snapshotSize;
  bool _captureScheduled = false;

  EdgeInsets get _padding => EdgeInsets.all(widget.strokeWidth.ceilToDouble());

  @override
  void initState() {
    super.initState();
    _scheduleCapture();
  }

  @override
  void didUpdateWidget(covariant OutlineShader oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.child != widget.child ||
        oldWidget.color != widget.color ||
        oldWidget.strokeWidth != widget.strokeWidth) {
      _scheduleCapture();
    }
  }

  @override
  void dispose() {
    _disposeSnapshot();
    super.dispose();
  }

  void _disposeSnapshot() {
    _snapshot?.dispose();
    _snapshot = null;
  }

  void _scheduleCapture() {
    if (_captureScheduled) {
      return;
    }

    _captureScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _captureScheduled = false;
      await _captureSnapshot();
    });
  }

  Future<void> _captureSnapshot() async {
    if (!mounted) {
      return;
    }

    final boundary =
        _boundaryKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;
    if (boundary == null || !boundary.hasSize) {
      _scheduleCapture();
      return;
    }

    if (boundary.debugNeedsPaint) {
      _scheduleCapture();
      return;
    }

    final pixelRatio = View.of(context).devicePixelRatio;
    final image = await boundary.toImage(pixelRatio: pixelRatio);
    final oldSnapshot = _snapshot;

    if (!mounted) {
      image.dispose();
      oldSnapshot?.dispose();
      return;
    }

    setState(() {
      _snapshot = image;
      _snapshotSize = boundary.size;
    });

    oldSnapshot?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paddedChild = Padding(padding: _padding, child: widget.child);

    return NotificationListener<SizeChangedLayoutNotification>(
      onNotification: (_) {
        _scheduleCapture();
        return false;
      },
      child: SizeChangedLayoutNotifier(
        child: Stack(
          fit: StackFit.passthrough,
          clipBehavior: Clip.none,
          children: [
            if (_snapshot != null && _snapshotSize != null)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _OutlinePainter(
                      image: _snapshot!,
                      imageSize: _snapshotSize!,
                      color: widget.color,
                      strokeWidth: widget.strokeWidth,
                      pixelRatio: View.of(context).devicePixelRatio,
                    ),
                  ),
                ),
              ),
            RepaintBoundary(key: _boundaryKey, child: paddedChild),
          ],
        ),
      ),
    );
  }
}

class _OutlinePainter extends CustomPainter {
  _OutlinePainter({
    required this.image,
    required this.imageSize,
    required this.color,
    required this.strokeWidth,
    required this.pixelRatio,
  });

  final ui.Image image;
  final Size imageSize;
  final Color color;
  final double strokeWidth;
  final double pixelRatio;

  @override
  void paint(Canvas canvas, Size size) {
    final shader = GameShaders.widgetOutline.fragmentShader()
      ..setFloat(0, imageSize.width <= 0 ? 1.0 : imageSize.width)
      ..setFloat(1, imageSize.height <= 0 ? 1.0 : imageSize.height)
      ..setFloat(2, color.r)
      ..setFloat(3, color.g)
      ..setFloat(4, color.b)
      ..setFloat(5, color.a)
      ..setFloat(6, strokeWidth)
      ..setFloat(7, pixelRatio)
      ..setImageSampler(0, image);

    canvas.drawRect(
      Offset.zero & imageSize,
      Paint()
        ..shader = shader
        ..isAntiAlias = false
        ..filterQuality = FilterQuality.none,
    );

    shader.dispose();
  }

  @override
  bool shouldRepaint(covariant _OutlinePainter oldDelegate) {
    return oldDelegate.image != image ||
        oldDelegate.imageSize != imageSize ||
        oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.pixelRatio != pixelRatio;
  }
}
