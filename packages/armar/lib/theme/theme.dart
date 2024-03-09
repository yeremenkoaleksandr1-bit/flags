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

extension ThemeExt on ThemeData {
  ThemeData merge(ThemeData other) {
    return copyWith(
      applyElevationOverlayColor: other.applyElevationOverlayColor,
      cupertinoOverrideTheme: other.cupertinoOverrideTheme,
      inputDecorationTheme: other.inputDecorationTheme,
      materialTapTargetSize: other.materialTapTargetSize,
      pageTransitionsTheme: other.pageTransitionsTheme,
      platform: other.platform,
      scrollbarTheme: other.scrollbarTheme,
      splashFactory: other.splashFactory,
      visualDensity: other.visualDensity,
      brightness: other.brightness,
      canvasColor: other.canvasColor,
      cardColor: other.cardColor,
      colorScheme: other.colorScheme,
      dialogBackgroundColor: other.dialogBackgroundColor,
      disabledColor: other.disabledColor,
      dividerColor: other.dividerColor,
      focusColor: other.focusColor,
      highlightColor: other.highlightColor,
      hintColor: other.hintColor,
      hoverColor: other.hoverColor,
      indicatorColor: other.indicatorColor,
      primaryColor: other.primaryColor,
      primaryColorDark: other.primaryColorDark,
      primaryColorLight: other.primaryColorLight,
      scaffoldBackgroundColor: other.scaffoldBackgroundColor,
      secondaryHeaderColor: other.secondaryHeaderColor,
      shadowColor: other.shadowColor,
      splashColor: other.splashColor,
      unselectedWidgetColor: other.unselectedWidgetColor,
      iconTheme: other.iconTheme,
      primaryIconTheme: other.primaryIconTheme,
      primaryTextTheme: other.primaryTextTheme,
      textTheme: other.textTheme,
      typography: other.typography,
      actionIconTheme: other.actionIconTheme,
      appBarTheme: other.appBarTheme,
      badgeTheme: other.badgeTheme,
      bannerTheme: other.bannerTheme,
      bottomAppBarTheme: other.bottomAppBarTheme,
      bottomNavigationBarTheme: other.bottomNavigationBarTheme,
      bottomSheetTheme: other.bottomSheetTheme,
      buttonBarTheme: other.buttonBarTheme,
      buttonTheme: other.buttonTheme,
      cardTheme: other.cardTheme,
      checkboxTheme: other.checkboxTheme,
      chipTheme: other.chipTheme,
      dataTableTheme: other.dataTableTheme,
      datePickerTheme: other.datePickerTheme,
      dialogTheme: other.dialogTheme,
      dividerTheme: other.dividerTheme,
      drawerTheme: other.drawerTheme,
      dropdownMenuTheme: other.dropdownMenuTheme,
      elevatedButtonTheme: other.elevatedButtonTheme,
      expansionTileTheme: other.expansionTileTheme,
      filledButtonTheme: other.filledButtonTheme,
      floatingActionButtonTheme: other.floatingActionButtonTheme,
      iconButtonTheme: other.iconButtonTheme,
      listTileTheme: other.listTileTheme,
      menuBarTheme: other.menuBarTheme,
      menuButtonTheme: other.menuButtonTheme,
      menuTheme: other.menuTheme,
      navigationBarTheme: other.navigationBarTheme,
      navigationDrawerTheme: other.navigationDrawerTheme,
      navigationRailTheme: other.navigationRailTheme,
      outlinedButtonTheme: other.outlinedButtonTheme,
      popupMenuTheme: other.popupMenuTheme,
      progressIndicatorTheme: other.progressIndicatorTheme,
      radioTheme: other.radioTheme,
      searchBarTheme: other.searchBarTheme,
      searchViewTheme: other.searchViewTheme,
      segmentedButtonTheme: other.segmentedButtonTheme,
      sliderTheme: other.sliderTheme,
      snackBarTheme: other.snackBarTheme,
      switchTheme: other.switchTheme,
      tabBarTheme: other.tabBarTheme,
      textButtonTheme: other.textButtonTheme,
      textSelectionTheme: other.textSelectionTheme,
      timePickerTheme: other.timePickerTheme,
      toggleButtonsTheme: other.toggleButtonsTheme,
      tooltipTheme: other.tooltipTheme,
      toggleableActiveColor: other.toggleableActiveColor,
      errorColor: other.errorColor,
      backgroundColor: other.backgroundColor,
      bottomAppBarColor: other.bottomAppBarColor,
    );
  }
}
