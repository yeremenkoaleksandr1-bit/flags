import 'dart:math';

import 'package:flags/presentation/game/puzzle/entities/colored_part.game_object.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/rendering.dart';

import '../../../../domain/game_objects/flag/flag.dart';
import '../../../../domain/game_objects/parts/parts.dart';
import 'super_easy.dart';

class PuzzleEasyGenerator extends PuzzleSuperEasyGenerator {
  final int quantityColoredPart;

  PuzzleEasyGenerator({
    this.quantityColoredPart = 1,
    super.quantityEmblem = 4,
    super.quantityParts = 5,
    super.multiplier = 1.5,
  });

  @override
  List<PathPart> generateParts(GameFlag flag, Random random) {
    const maxRandomColorsQuantity = 4;

    final superParts = super.generateParts(flag, random);

    final List<PathPart> parts = [];

    for (var i = 0; i < quantityColoredPart; i++) {
      final superPart = superParts.random(random);
      superParts.remove(superPart);
      List<Color> colors = [
        superPart.color,
      ];

      colors.addAll(
        _generateUniqueColors(
          superPart.color,
          maxRandomColorsQuantity,
          random,
        ),
      );

      colors.shuffle(random);

      parts.add(
        ColoredPart(
          name: superPart.name,
          uniqueName: superPart.uniqueName,
          path: superPart.path,
          position: superPart.position,
          size: superPart.size,
          scale: superPart.scale,
          rotation: superPart.rotation,
          colors: colors,
        ),
      );
    }

    return [...superParts, ...parts];
  }

  List<Color> _generateUniqueColors(
      Color originalColor, int len, Random random) {
    // Extract original color's HSV values
    final HSVColor originalHSV = HSVColor.fromColor(originalColor);
    final double originalSaturation = originalHSV.saturation;

    // Generate random colors with similar saturation
    final uniqueColors = List.generate(len, (_) {
      final double randomHue = random.nextDouble() * 360.0;
      final double randomValue =
          random.nextDouble() * (1.0 - originalSaturation) + originalSaturation;

      // Convert HSV back to Color
      return HSVColor.fromAHSV(1.0, randomHue, originalSaturation, randomValue)
          .toColor();
    });

    return uniqueColors;
  }
}
