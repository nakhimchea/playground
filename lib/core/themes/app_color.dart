part of styles;

class AppColors {
  // Text Color
  static const Color primaryText = Colors.white; //Color(0xff242424);
  static const Color secondText = Color(0xffffffff);
  static const Color disableText = Color(0xffcccccc);
  static const Color headerText = Color(0xff242424);

  // Color Feature.
  static const MaterialColor primarySwatch = Colors.indigo;

  static const Color primary = Color.fromARGB(255, 75, 77,
      77); //App Bar background, Primary Buttons ("Submit"),Active tab or selected, Key highlights/branding elements
  static const Color onPrimary =
      Color(0xFFFFFFFF); // thing that display on primary color ex primary App Bar with onPrimary text on it
  static const Color primaryVariant = Color(0xFFA6BD95);
  static const Color background = Color.fromARGB(255, 36, 34, 46);
  static const Color onBackground = Color(0xffEEEEEE);
  static const Color surface =
      Color(0xff262626); // Background for components like cards, sheets, and menus (dialog background)
  static const Color onSurface = Color(0xFFFFFFFF); // Background for components like cards, sheets, and menus
  static const Color secondary =
      Color(0xff165c53); //Secondary actions like floating action buttons, selection controls, and highlights
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryVariant = Color.fromARGB(255, 109, 146, 149);
  static const Color error = Color(0xFFD53A2F);
  static const Color onError = Color(0xFFFFFFFF);
  //UI
  static const chatBackgroundColor = Color(0xff171717);
  static const chatSideBarBackgroundColor = Color(0xff0D0D0D);
  static const chatTextInputBackgroundColor = Color(0xff212121);
  static const dividerColor = Color(0xFFF5F6F8);
  static const darkDividerColor = Color(0x3C3C434D);
  static const darkBorderColor = Color(0xFF98A3B3);
  static const lightGreyBackground = Color(0xFFF2F3F7);
  static const audioBarBackground = Color(0xFF0160CC);
  static const snackbarGreen = Color(0xFF18B23C);
  static const snackbarRed = Color(0xFFDE002C);
  static const snackbarBackground = Color(0xFF041628);
  static const controlBarBuffer = Color(0xFF646464);
  static const issueFlowAttemptText = Color(0xFFF9A01B);
  static const lightGreyIconColor = Color.fromARGB(255, 211, 209, 205);

  static const ticketOpen = Color(0xFFF9A01B);
  static const ticketInProgress = Color(0xFF0077FF);
  static const ticketResolve = Color(0xFF0077FF);
  static const ticketClose = Color(0xFF3CC162);

  // Textbox
  static const Color textBoxBg = Color(0xffF5F5F5);
  static const Color textBoxHint = Color(0xffcccccc);

  // Other Color
  static const Color white = Color(0xffffffff);
  static const Color blue = Color(0xff115793);
  static const Color blueLight = Color(0xff00A1CB);
  static const Color cyan = Color(0xff0ABEBE);
  static const Color cyanLight = Color.fromARGB(255, 153, 232, 232);
  static const Color green = Color(0xff3A7634);
  static const Color greenLight = Color(0xff5EB11C);
  static const Color yellow = Color(0xffF2BC06);
  static const Color yellowLight = Color.fromARGB(255, 241, 222, 161);
  static const Color orange = Color(0xffF18D05);
  static const Color red = Color(0xffE54028);
  static const Color pink = Color(0xffD70060);
  static const Color purple = Color(0xff5A4296);
  static const Color grey = Color.fromARGB(255, 154, 150, 150);

  // Colors List
  static const List<Color> colors = [primary, blue, blueLight, cyan, green, greenLight, yellow, orange, red, pink];

  // Gradient Color
  static const Gradient secondaryGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: [
      0,
      1,
    ],
    colors: [
      Color.fromARGB(255, 129, 100, 205),
      Color.fromARGB(255, 86, 158, 222),
    ],
  );

  static const Gradient pinkGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: [
      0,
      1,
    ],
    colors: [
      Color(0xffD70060),
      Color(0xffD70060),
    ],
  );

  static const Gradient whiteGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    stops: [
      0,
      1,
    ],
    colors: [
      Color(0xffffffff),
      Color(0xffffffff),
    ],
  );

  static const Gradient planningGradient = LinearGradient(
    begin: Alignment(0.5, 0), //Alignment.topCenter,
    end: Alignment(0.4, 1),
    colors: [
      Color(0xE6FE7B5D),
      Color(0xE6EB399B),
    ],
  );

  static const Gradient planningGradient1 = LinearGradient(
    begin: Alignment(1, 0), //Alignment.topCenter,
    end: Alignment(0.6, 1),
    colors: [
      Color(0xE6EF3E96),
      Color(0xE6BE3CDA),
    ],
  );

  static const Gradient planningGradient2 = LinearGradient(
    begin: Alignment(1, 0), //Alignment.topCenter,
    end: Alignment(0.6, 1),
    colors: [
      Color(0xE6C63AD6),
      Color(0xE6406AE7),
    ],
  );

  static const Gradient menuBlackGradient = LinearGradient(
    begin: FractionalOffset.topCenter,
    end: FractionalOffset.bottomCenter,
    colors: [
      Color(0x00000000),
      Color.fromARGB(200, 0, 0, 0),
    ],
  );

  static const Gradient menuPrimaryGradient = LinearGradient(
    begin: FractionalOffset.topCenter,
    end: FractionalOffset.bottomCenter,
    stops: [
      0,
      1,
    ],
    colors: [
      Color(0x00009688),
      Color(0xff009688),
    ],
  );
}
