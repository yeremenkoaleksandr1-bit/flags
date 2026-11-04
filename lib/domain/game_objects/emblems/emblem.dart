import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flags/core/extensions/image.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../interfaces/interfaces.dart';

class Emblem implements IDrawable {
  Emblem({
    required this.name,
    required String assetPath,
    this.symmetrical180 = false,
    this.symmetrical90 = false,
    this.identicalRotation = false,
  }) : _assetPath = assetPath;

  /// Emblems are decoded at most this many pixels on their longest side.
  ///
  /// Source PNGs are up to 1500x1500; decoding all 118 at full size took
  /// ~368 MB of memory at startup. Decoding at <= 1024 px takes ~211 MB and
  /// still has more pixels than an emblem ever covers on screen.
  static const int maxDecodedSide = 1024;

  final String name;
  final String _assetPath;

  /// Decoded (possibly downscaled) bitmap. Use [size] for geometry.
  late final UIImage image;

  /// Logical emblem size: the pixel size of the source asset.
  ///
  /// Game logic (placement, scaling, hit areas) is expressed in these units,
  /// so it stays the same regardless of the decoded [image] resolution.
  late final Vector2 size;

  final bool symmetrical180;
  final bool symmetrical90;
  final bool identicalRotation;

  Future<void> load() async {
    final data = await rootBundle.load('assets/images/emblems/$_assetPath.png');
    final buffer = await ui.ImmutableBuffer.fromUint8List(
      data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
    );
    final descriptor = await ui.ImageDescriptor.encoded(buffer);

    final width = descriptor.width;
    final height = descriptor.height;
    size = Vector2(width.toDouble(), height.toDouble());

    final scale = math.min(1.0, maxDecodedSide / math.max(width, height));
    final codec = await descriptor.instantiateCodec(
      targetWidth: math.max(1, (width * scale).round()),
      targetHeight: math.max(1, (height * scale).round()),
    );
    final frame = await codec.getNextFrame();
    image = frame.image;

    codec.dispose();
    descriptor.dispose();
    buffer.dispose();
  }

  final _paint = Paint()..filterQuality = FilterQuality.medium;

  @override
  void draw(ui.Canvas canvas, ui.Size size) {
    canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      Rect.fromLTWH(0, 0, this.size.x, this.size.y),
      _paint,
    );
  }
}
