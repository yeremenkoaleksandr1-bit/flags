import 'package:armar/form_builder/themes/form_field.theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../armar.dart';
import '../components/screens/themes/screen_theme.dart';
import '../components/scrollable/themes/ar_scrollable_view_theme.dart';
import '../form_builder/fields/search_field/theme/search_field.theme.dart';
import '../form_builder/fields/themes/date_picker.theme.dart';
import '../form_builder/fields/themes/text_field.theme.dart';
import '../form_builder/themes/password_field.theme.dart';

class ArmarThemeData with Diagnosticable {
  final ArScreenTheme screenTheme;
  final ArScrollableViewTheme scrollableViewTheme;

  final ArLabelFieldTheme labelFieldTheme;
  final ArFormBuilderTextFieldTheme textFieldTheme;
  final ArPasswordFieldTheme passwordFieldTheme;
  final ArFormBuilderDatePickerTheme datePickerTheme;

  final ThemeData materialTheme;

  final ArSearchFieldTheme searchFieldTheme;

  const ArmarThemeData({
    required this.materialTheme,
    this.screenTheme = const ArScreenTheme(
      contentPadding: EdgeInsets.all(8),
    ),
    this.scrollableViewTheme = const ArScrollableViewTheme(),
    this.labelFieldTheme = const ArLabelFieldTheme(),
    this.passwordFieldTheme = const ArPasswordFieldTheme(),
    this.textFieldTheme = const ArFormBuilderTextFieldTheme(
      spaceBetweenFieldAndErrors: 4,
      spaceBetweenErrors: 2,
    ),
    this.searchFieldTheme = const ArSearchFieldTheme(),
    this.datePickerTheme = const ArFormBuilderDatePickerTheme(),
  });

  List<ThemeExtension> get themes => [
        labelFieldTheme,
        textFieldTheme,
        scrollableViewTheme,
        screenTheme,
        passwordFieldTheme,
        searchFieldTheme,
        datePickerTheme,
      ];
}
