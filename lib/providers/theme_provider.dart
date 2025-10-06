import 'package:flutter/material.dart';

import '../config/configs.dart';
import '../helpers/enumerations.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeOption = PlaygroundTheme.dark;

  ThemeData get themeOption => _themeOption;

  void setTheme(ThemeType themeType) {
    switch (themeType) {
      case ThemeType.light:
        _themeOption = PlaygroundTheme.light;
        break;
      case ThemeType.dark:
        _themeOption = PlaygroundTheme.dark;
        break;
    }
    notifyListeners();
  }

  void clearTheme() {
    _themeOption = PlaygroundTheme.dark;
    notifyListeners();
  }
}

class PlaygroundTheme {
  static final light = ThemeData(
    brightness: Brightness.light,
    primaryColor: Palette.primary,
    primaryColorDark: Palette.primary,
    primaryColorLight: Palette.primary,
    focusColor: Colors.transparent,
    hoverColor: Colors.transparent,
    shadowColor: Colors.black38,
    canvasColor: Colors.white,
    scaffoldBackgroundColor: const Color(0xFFF6F8FA),
    cardColor: Colors.white,
    dividerColor: Colors.grey.shade300,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    unselectedWidgetColor: const Color(0x00000000),
    disabledColor: const Color(0xFFDADADA),
    secondaryHeaderColor: Palette.secondary,
    indicatorColor: const Color(0x00000000),
    hintColor: Palette.tertiary,
    primaryIconTheme: const IconThemeData(color: Color(0xFF000D44)),
    iconTheme: const IconThemeData(color: Color(0xFF91949A)),
    primaryTextTheme: TextTheme(
      displayLarge: kPDisplayTextStyle.copyWith(
        color: const Color(0xFF000D44),
        fontSize: 30,
      ),
      displayMedium: kPDisplayTextStyle.copyWith(
        color: const Color(0xFF000D44),
        fontSize: 26,
      ),
      displaySmall: kPDisplayTextStyle.copyWith(
        color: const Color(0xFF000D44),
        fontSize: 22,
      ),
      titleLarge: kPTitleTextStyle.copyWith(
        color: const Color(0xFF000D44),
        fontSize: 18,
      ),
      titleMedium: kPTitleTextStyle.copyWith(
        color: const Color(0xFF000D44),
        fontSize: 16,
      ),
      titleSmall: kPTitleTextStyle.copyWith(
        color: const Color(0xFF000D44),
        fontSize: 14,
      ),
      headlineLarge: kPHeadlineTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 16,
      ),
      headlineMedium: kPHeadlineTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 14,
      ),
      headlineSmall: kPHeadlineTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 12,
      ),
      labelLarge: kPLabelTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 24,
      ),
      labelMedium: kPLabelTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 22,
      ),
      labelSmall: kPLabelTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 18,
      ),
      bodyLarge: kPBodyTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 16,
      ),
      bodyMedium: kPBodyTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 14,
      ),
      bodySmall: kPBodyTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 12,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: kDisplayTextStyle.copyWith(
        color: const Color(0xFF000D44),
        fontSize: 26,
      ),
      displayMedium: kDisplayTextStyle.copyWith(
        color: const Color(0xFF000D44),
        fontSize: 22,
      ),
      displaySmall: kDisplayTextStyle.copyWith(
        color: const Color(0xFF000D44),
        fontSize: 18,
      ),
      titleLarge: kTitleTextStyle.copyWith(
        color: const Color(0xFF000D44),
        fontSize: 16,
      ),
      titleMedium: kTitleTextStyle.copyWith(
        color: const Color(0xFF000D44),
        fontSize: 14,
      ),
      titleSmall: kTitleTextStyle.copyWith(
        color: const Color(0xFF000D44),
        fontSize: 12,
      ),
      headlineLarge: kHeadlineTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 14,
      ),
      headlineMedium: kHeadlineTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 12,
      ),
      headlineSmall: kHeadlineTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 10,
      ),
      labelLarge: kLabelTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 22,
      ),
      labelMedium: kLabelTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 20,
      ),
      labelSmall: kLabelTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 17,
      ),
      bodyLarge: kBodyTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 15,
      ),
      bodyMedium: kBodyTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 13,
      ),
      bodySmall: kBodyTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 11,
      ),
    ),
    colorScheme: const ColorScheme.light(),
  );
  static final dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Palette.primary,
    primaryColorDark: Palette.primary,
    primaryColorLight: Palette.primary,
    focusColor: Colors.transparent,
    hoverColor: Colors.transparent,
    shadowColor: Colors.black38,
    canvasColor: Colors.black,
    scaffoldBackgroundColor: const Color(0xFF121212),
    cardColor: Colors.black,
    dividerColor: Colors.grey.shade800,
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    unselectedWidgetColor: const Color(0x00000000),
    disabledColor: const Color(0x33FFFFFF),
    secondaryHeaderColor: Palette.secondary,
    indicatorColor: const Color(0x00000000),
    hintColor: Palette.tertiary,
    primaryIconTheme: const IconThemeData(color: Color(0xDDFFFFFF)),
    iconTheme: const IconThemeData(color: Color(0xFF91949A)),
    primaryTextTheme: TextTheme(
      displayLarge: kPDisplayTextStyle.copyWith(
        color: const Color(0xDDFFFFFF),
        fontSize: 30,
      ),
      displayMedium: kPDisplayTextStyle.copyWith(
        color: const Color(0xDDFFFFFF),
        fontSize: 26,
      ),
      displaySmall: kPDisplayTextStyle.copyWith(
        color: const Color(0xDDFFFFFF),
        fontSize: 22,
      ),
      titleLarge: kPTitleTextStyle.copyWith(
        color: const Color(0xDDFFFFFF),
        fontSize: 18,
      ),
      titleMedium: kPTitleTextStyle.copyWith(
        color: const Color(0xDDFFFFFF),
        fontSize: 16,
      ),
      titleSmall: kPTitleTextStyle.copyWith(
        color: const Color(0xDDFFFFFF),
        fontSize: 14,
      ),
      headlineLarge: kPHeadlineTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 16,
      ),
      headlineMedium: kPHeadlineTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 14,
      ),
      headlineSmall: kPHeadlineTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 12,
      ),
      labelLarge: kPLabelTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 24,
      ),
      labelMedium: kPLabelTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 22,
      ),
      labelSmall: kPLabelTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 18,
      ),
      bodyLarge: kPBodyTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 16,
      ),
      bodyMedium: kPBodyTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 14,
      ),
      bodySmall: kPBodyTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 12,
      ),
    ),
    textTheme: TextTheme(
      displayLarge: kDisplayTextStyle.copyWith(
        color: const Color(0xDDFFFFFF),
        fontSize: 26,
      ),
      displayMedium: kDisplayTextStyle.copyWith(
        color: const Color(0xDDFFFFFF),
        fontSize: 22,
      ),
      displaySmall: kDisplayTextStyle.copyWith(
        color: const Color(0xDDFFFFFF),
        fontSize: 18,
      ),
      titleLarge: kTitleTextStyle.copyWith(
        color: const Color(0xDDFFFFFF),
        fontSize: 16,
      ),
      titleMedium: kTitleTextStyle.copyWith(
        color: const Color(0xDDFFFFFF),
        fontSize: 14,
      ),
      titleSmall: kTitleTextStyle.copyWith(
        color: const Color(0xDDFFFFFF),
        fontSize: 12,
      ),
      headlineLarge: kHeadlineTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 14,
      ),
      headlineMedium: kHeadlineTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 12,
      ),
      headlineSmall: kHeadlineTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 10,
      ),
      labelLarge: kLabelTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 22,
      ),
      labelMedium: kLabelTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 20,
      ),
      labelSmall: kLabelTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 17,
      ),
      bodyLarge: kBodyTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 15,
      ),
      bodyMedium: kBodyTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 13,
      ),
      bodySmall: kBodyTextStyle.copyWith(
        color: const Color(0xFF91949A),
        fontSize: 11,
      ),
    ),
    colorScheme: const ColorScheme.dark(),
  );
}
