import 'package:flutter/material.dart';

import '../../drop_down_search_field/dropdown/src/suggestions/suggestions_box_decoration.dart';

class ArSearchFieldTheme extends ThemeExtension<ArSearchFieldTheme> {
  final InputDecoration Function(bool hasChoose)? decoration;

  final IconData closeIcon;
  final IconThemeData closeIconTheme;

  final IconData dropDownIcon;
  final IconThemeData dropDownIconTheme;

  final SuggestionsBoxDecoration suggestionsBoxDecoration;

  const ArSearchFieldTheme({
    this.decoration,
    this.closeIcon = Icons.close,
    this.closeIconTheme = const IconThemeData(),
    this.dropDownIcon = Icons.keyboard_arrow_down,
    this.dropDownIconTheme = const IconThemeData(),
    this.suggestionsBoxDecoration = const SuggestionsBoxDecoration(
      color: Colors.white,
      shadowColor: Color(0x336C6E75),
      elevation: 10,
      constraints: BoxConstraints(minHeight: 300),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 1,
          color: Colors.grey,
        ),
      ),
    ),
  });

  @override
  ThemeExtension<ArSearchFieldTheme> lerp(
    covariant ThemeExtension<ArSearchFieldTheme>? other,
    double t,
  ) {
    return this;
  }

  ArSearchFieldTheme copyWith({
    InputDecoration Function(bool hasChoosed)? decoration,
    IconData? closeIcon,
    IconThemeData? closeIconTheme,
    IconData? dropDownIcon,
    IconThemeData? dropDownIconTheme,
    SuggestionsBoxDecoration? suggestionsBoxDecoration,
  }) {
    return ArSearchFieldTheme(
      decoration: decoration ?? this.decoration,
      closeIcon: closeIcon ?? this.closeIcon,
      closeIconTheme: closeIconTheme ?? this.closeIconTheme,
      dropDownIcon: dropDownIcon ?? this.dropDownIcon,
      dropDownIconTheme: dropDownIconTheme ?? this.dropDownIconTheme,
      suggestionsBoxDecoration:
          suggestionsBoxDecoration ?? this.suggestionsBoxDecoration,
    );
  }
}
