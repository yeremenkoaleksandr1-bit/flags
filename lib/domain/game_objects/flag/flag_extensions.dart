import 'package:flags/domain/game_objects/emblems/emblem.gameObject.dart';
import 'package:flutter/material.dart';

import '../game_objects.dart';
import 'flag.dart';

extension FlagExtensions on GameFlag {
  List<PathPart> get fabrics => [...objects.whereType<PathPart>()];

  List<EmblemPart> get emblems => [...objects.whereType<EmblemPart>()];

  void drawRect(Canvas canvas, Size size) {
    for (GameObject object in objects) {
      canvas.save();

      canvas.drawRect(
        object.rect,
        Paint()
          ..color = Colors.pink
          ..blendMode = BlendMode.difference
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.25,
      );
      canvas.restore();
    }
  }

  GameFlag copyWith({
    String? name,
    List<PathPart>? objects,
    double? proportion,
  }) {
    return GameFlag(
      name: name ?? this.name,
      objects: (size) => objects ?? this.objects,
      proportion: proportion ?? this.proportion,
    );
  }
}
