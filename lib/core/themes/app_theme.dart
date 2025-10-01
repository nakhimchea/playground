part of styles;

class AppTheme {
  AppTheme._();

  static String appName = "Iceberg X-Change";

  // ******************************
  // Primary Theme
  // ******************************

  static const TextStyle h1 = TextStyle(
      // h1
      fontWeight: FontWeight.bold,
      fontSize: 40,
      color: AppColors.headerText);

  static const TextStyle h2 = TextStyle(
      // h2
      fontSize: 30,
      color: AppColors.secondText);

  static const TextStyle h3 = TextStyle(
      // h3
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.secondText);

  static const TextStyle h4 = TextStyle(
      // h4
      fontSize: 24,
      color: AppColors.secondText);

  static const TextStyle h5 = TextStyle(
    // h5 -> headline
    fontWeight: FontWeight.w600,
    fontSize: 18,
    //color: AppColors.white
  );

  static const TextStyle h6 = TextStyle(
      // h6 -> title
      fontSize: 18,
      color: AppColors.white);

  static const TextStyle subtitle1 = TextStyle(
    // subtitle1 -> subhead
    fontWeight: FontWeight.w600,
    fontSize: 16,
  );

  static const TextStyle subtitle2 = TextStyle(
    // subtitle2 -> subtitle
    fontSize: 16,
  );

  static const TextStyle body1 = TextStyle(
    // body2 -> body1
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  static const TextStyle body2 = TextStyle(
    // body1 -> body2
    fontSize: 14,
  );

  static const TextStyle caption = TextStyle(
      // Caption -> caption
      fontSize: 14);

  static const button = TextStyle(
      // Button
      fontWeight: FontWeight.w500,
      fontSize: 14,
      letterSpacing: 1.5,
      color: AppColors.secondText // was lightText
      );

  static const TextStyle overline = TextStyle(
      // overline
      fontWeight: FontWeight.normal,
      letterSpacing: 0,
      fontSize: 12);

  static TextTheme lightTextTheme = const TextTheme(
          displayLarge: h1,
          displayMedium: h2,
          displaySmall: h3,
          headlineMedium: h4,
          headlineSmall: h5,
          titleLarge: h6,
          titleMedium: subtitle1,
          titleSmall: subtitle2,
          bodyLarge: body1,
          bodyMedium: body2,
          labelLarge: button,
          bodySmall: caption,
          labelSmall: overline)
      .apply(fontFamily: GoogleFonts.lato().fontFamily);

  static ThemeData lightTheme = ThemeData(
    // Define the default brightness and colors.
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    canvasColor: AppColors.primary,
    splashColor: AppColors.secondary,
    textTheme: lightTextTheme, // GoogleFonts.latoTextTheme().apply(bodyColor: AppColors.primaryText), // lightTextTheme,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30),
          ),
        ),
      ),
    ),
    iconTheme: const IconThemeData(color: AppColors.primaryText),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.primary,
      splashColor: AppColors.secondary,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      secondary: AppColors.secondary,
      onPrimary: AppColors.onPrimary,
      onSecondary: AppColors.onSecondary,
      error: AppColors.error,
      onError: AppColors.onError,
      surface: Color.fromARGB(255, 83, 83, 87),
      onSurface: AppColors.onSurface,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      selectionColor: Color.fromARGB(255, 149, 213, 246),
      selectionHandleColor: Color.fromARGB(255, 149, 213, 246),
    ),
  );
  static ThemeData dartTheme = ThemeData(
    // Define the default brightness and colors.
    brightness: Brightness.dark,
    primaryColor: const Color.fromARGB(255, 31, 35, 59),
    scaffoldBackgroundColor: AppColors.background,
    canvasColor: const Color.fromARGB(255, 31, 35, 59),
    splashColor: AppColors.secondary,
    textTheme: GoogleFonts.latoTextTheme().apply(bodyColor: AppColors.primaryText),
    cardColor: Colors.red,
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 31, 35, 59),
        padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(12),
          ),
        ),
      ),
    ),
    iconTheme: const IconThemeData(color: AppColors.primaryText),
    buttonTheme: const ButtonThemeData(
      buttonColor: AppColors.primary,
      splashColor: AppColors.secondary,
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    colorScheme: ColorScheme.fromSwatch(primarySwatch: AppColors.primarySwatch).copyWith(
      surface: AppColors.background,
    ),
  );
}
