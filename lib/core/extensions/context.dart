import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  ThemeData get themeData => Theme.of(this);

  double get topPadding => mediaQuery.padding.top;

  double get bottomPadding => mediaQuery.padding.bottom;

  double get bottomInsets => mediaQuery.viewInsets.bottom;
}
