import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vikunja_app/theme/constants.dart';

ThemeData buildVikunjaTheme() => _buildVikunjaTheme(ThemeData.light());
ThemeData buildVikunjaDarkTheme() => _buildVikunjaTheme(ThemeData.dark());

ThemeData _buildVikunjaTheme(ThemeData base) {
  return base.copyWith(
    errorColor: vRed,
    primaryColor: vPrimaryDark,
    primaryColorLight: vPrimary,
    primaryColorDark: vBlueDark,
    colorScheme: base.colorScheme.copyWith(
      primary: vPrimaryDark,
      secondary: vPrimary,
    ),
    floatingActionButtonTheme: base.floatingActionButtonTheme.copyWith(
      foregroundColor: vWhite,
    ),
    textTheme: base.textTheme.copyWith(
//      headline: base.textTheme.headline.copyWith(
//        fontFamily: 'Quicksand',
//      ),
//      title: base.textTheme.title.copyWith(
//        fontFamily: 'Quicksand',
//      ),
      button: base.textTheme.button.copyWith(
        color:
            vWhite, // This does not work, looks like a bug in Flutter: https://github.com/flutter/flutter/issues/19623
      ),
    ),
    bottomNavigationBarTheme: base.bottomNavigationBarTheme.copyWith(
      // Make bottomNavigationBar backgroundColor darker to provide more separation
      backgroundColor: () {
        final _hslColor = HSLColor.fromColor(
            base.bottomNavigationBarTheme.backgroundColor
            ?? base.scaffoldBackgroundColor
        );
        return _hslColor.withLightness(max(_hslColor.lightness - 0.03, 0)).toColor();
      }(),
    ),
  );
}
