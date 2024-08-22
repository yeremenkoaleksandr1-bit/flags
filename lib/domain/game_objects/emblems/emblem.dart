import 'dart:ui' as ui;

import 'package:flags/core/extensions/image.dart';
import 'package:flags/domain/game_objects/emblems/emblem.gameObject.dart';
import 'package:flags/uikit/assets/images/ui_image_assets.dart';
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

  final String name;
  final String _assetPath;
  late final UIImage image;

  final bool symmetrical180;
  final bool symmetrical90;
  final bool identicalRotation;

  Future<void> load() async {
    final asset = await UIImageAsset.load('emblems/$_assetPath.png');

    image = asset.image;
  }

  final _emptyPaint = Paint();

  @override
  void draw(ui.Canvas canvas, ui.Size size) {
    canvas.drawImage(image, Offset.zero, _emptyPaint);
  }
}
