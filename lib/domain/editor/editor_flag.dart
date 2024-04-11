import 'package:flags/domain/editor/styles/clear_style.dart';
import 'package:flags/domain/editor/styles/style.dart';
import 'package:flags/domain/game_objects/flag/flag.dart';
import 'package:flags/domain/game_objects/game_objects.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class EditorFlagData {
  final String name;

  final double proportion;

  final List<GameObject> objects;

  late final FlagStyle backgroundStyle;

  Rect get rect =>
      Vector2(GameFlag.defaultSize.x, GameFlag.defaultSize.y / proportion)
          .toRect();

  EditorFlagData({
    required this.name,
    required this.proportion,
    this.objects = const [],
  }) {
    backgroundStyle = ClearStyle(
      rect: rect,
      colors: [
        Colors.white,
      ],
    );
  }
}
