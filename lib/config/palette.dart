import 'package:flutter/material.dart';

class Palette {
  static const Color primary = Color(0xFFFF9988);
  static const Color secondary = Color(0xFFEF8632);
  static const Color tertiary = Color(0xFF305CCE);
  static const Color quaternary = Color(0xFFC23616);
  static const Color quinary = Colors.pink;
  static const Color senary = Color(0xFF30AD4C);
  static const Color septenary = Color(0xFF9D4CCC);
  static const Color lowKey = Colors.grey;

  static List<Color> textGradient = [
    const Color(0xFFC8A8BD),
    const Color(0xFFB4AAF0),
  ];

  static List<Color> textDeepGradient = [
    tertiary,
    Colors.purpleAccent,
    primary,
  ];

  static List<Color> kM3Light = [
    const Color(0xFFAEEFFF),
    const Color(0xFFEFEECA),
    const Color(0xFFFFD9E4),
    const Color(0xFFF8DFCF),
    const Color(0xFFCAE6FD),
    const Color(0xFFE5E4D0),
    const Color(0xFFEADEFF),
    const Color(0xFFC8F2CA),
  ];

  static List<Color> kM3Dark = [
    const Color(0xAAAEEFFF),
    const Color(0xCCEFEECA),
    const Color(0xCCFFD9E4),
    const Color(0xCCF8DFCF),
    const Color(0xCCCAE6FD),
    const Color(0xCCE5E4D0),
    const Color(0xDDEADEFF),
    const Color(0xCCC8F2CA),
  ];

  static const List<Color> attractiveBorderGradientLight = [
    Color(0xFFFF9988),
    Color(0xFFEF8632),
    Color(0xFFF6F8FA),
    Color(0xFFF6F8FA),
    Color(0xFFF6F8FA),
    Color(0xFFF6F8FA),
    Color(0xFFF6F8FA),
    Color(0xFFF6F8FA),
    Color(0xFFF6F8FA),
  ];

  static const List<Color> attractiveBorderGradientDark = [
    Color(0xAAFF9988),
    Color(0xAAEF8632),
    Color(0xFF121212),
    Color(0xFF121212),
    Color(0xFF121212),
    Color(0xFF121212),
    Color(0xFF121212),
    Color(0xFF121212),
    Color(0xFF121212),
  ];
}
