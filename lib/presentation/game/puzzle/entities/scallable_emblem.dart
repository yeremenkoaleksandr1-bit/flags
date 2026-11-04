// ignore_for_file: must_be_immutable
import 'package:flags/domain/game_objects/emblems/emblem.gameObject.dart';
import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';

import '../../../../domain/game_objects/emblems/emblem.dart';

class ScalableEmblemPart extends EmblemPart {
  ScalableEmblemPart({
    super.key,
    required super.emblem,
    String? name,
    super.position,
    super.scale,
    super.size,
    super.rotation,
    super.flippedHorizontal,
    super.flippedVertical,
    super.uniqueName,
    super.previousMustBePlaced,
    required this.scales,
  });

  final List<double> scales;

  factory ScalableEmblemPart.fromEmblem(
    EmblemPart emblemPart, {
    required List<double> scales,
  }) {
    return ScalableEmblemPart(
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

  @override
  ScalableEmblemPart copyWith({
    Key? key,
    String? name,
    Vector2? position,
    double? scale,
    Vector2? size,
    double? rotation,
    Emblem? emblem,
    bool? flippedHorizontal,
    bool? flippedVertical,
    List<String>? previousMustBePlaced,
    String? uniqueName,
    int? correctScaleIndex,
    List<double>? scales,
  }) {
    return ScalableEmblemPart(
      key: key ?? this.key,
      name: name ?? this.name,
      uniqueName: this.uniqueName ?? uniqueName,
      emblem: emblem ?? this.emblem,
      position: position ?? this.position,
      scale: scale ?? this.scale,
      size: size ?? this.size,
      rotation: rotation ?? this.rotation,
      flippedHorizontal: flippedHorizontal ?? this.flippedHorizontal,
      flippedVertical: flippedVertical ?? this.flippedVertical,
      previousMustBePlaced: previousMustBePlaced ?? this.previousMustBePlaced,
      scales: scales ?? this.scales,
    )..initialEmblemSize = initialEmblemSize;
  }
}
