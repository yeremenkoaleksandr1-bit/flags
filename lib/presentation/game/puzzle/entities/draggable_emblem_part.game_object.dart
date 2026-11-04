// ignore_for_file: must_be_immutable
import 'dart:ui';

import 'package:flags/domain/game_objects/emblems/emblem.gameObject.dart';
import 'package:flags/presentation/game/puzzle/entities/scallable_emblem.dart';

class DraggableEmblemPart extends ScalableEmblemPart {
  DraggableEmblemPart({
    super.key,
    required super.emblem,
    super.name,
    super.position,
    super.scale,
    super.size,
    super.rotation,
    super.flippedHorizontal,
    super.flippedVertical,
    super.uniqueName,
    super.previousMustBePlaced,
    required super.scales,
  });

  @override
  void draw(Canvas canvas, Size size) {
    emblem.draw(canvas, size);
  }

  factory DraggableEmblemPart.fromEmblem(
    EmblemPart emblemPart, {
    required List<double> scales,
  }) {
    return DraggableEmblemPart(
      key: emblemPart.key,
      name: emblemPart.name,
      uniqueName: emblemPart.uniqueName,
      emblem: emblemPart.emblem,
      position: emblemPart.position,
      scale: emblemPart.scale,
      size: emblemPart.size,
      rotation: emblemPart.rotation,
      flippedHorizontal: emblemPart.flippedHorizontal,
      flippedVertical: emblemPart.flippedVertical,
      previousMustBePlaced: emblemPart.previousMustBePlaced,
      scales: scales,
    );
  }

  EmblemPart toEmblemPart() {
    return EmblemPart(
      key: key,
      emblem: emblem,
      name: name,
      position: position,
      scale: scale,
      size: size,
      rotation: rotation,
      flippedHorizontal: flippedHorizontal,
      flippedVertical: flippedVertical,
      uniqueName: uniqueName,
      previousMustBePlaced: previousMustBePlaced,
    );
  }
}
