import 'package:equatable/equatable.dart';
import 'package:flags/domain/editor/styles/clear_style.dart';
import 'package:flags/domain/editor/styles/style.dart';
import 'package:flags/domain/game_objects/flag/flag.dart';
import 'package:flags/domain/game_objects/game_objects.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class EditorFlagData extends Equatable {
  final String name;

  final double proportion;

  final List<GameObject> objects;

  late FlagStyle backgroundStyle;

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

  EditorFlagData clone() {
    final data = EditorFlagData(
      name: name,
      proportion: proportion,
      objects: [
        ...objects.map((e) => e.copyWith()),
      ],
    );

    data.backgroundStyle = backgroundStyle;
    return data;
  }

  EditorFlagData copyWith({
    String? name,
    double? proportion,
    List<GameObject>? objects,
    FlagStyle? backgroundStyle,
  }) {
    final data = EditorFlagData(
      name: name ?? this.name,
      proportion: proportion ?? this.proportion,
      objects: objects ?? this.objects,
    );

    data.backgroundStyle = backgroundStyle ?? this.backgroundStyle;

    return data;
  }

  @override
  List<Object?> get props => [
        name,
        objects,
        backgroundStyle,
        proportion,
      ];
}
