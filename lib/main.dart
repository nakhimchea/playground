import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:playground/config/constant.dart'
    show
        firebaseOptionsApiKey,
        firebaseOptionsAuthDomain,
        firebaseOptionsProjectId,
        firebaseOptionsStorageBucket,
        firebaseOptionsMessagingSenderId,
        firebaseOptionsAppId,
        firebaseOptionsMeasurementId;
import 'package:provider/provider.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'config/variable.dart';
import 'l10n/locales.dart';
import 'providers/locale_provider.dart';
import 'providers/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: firebaseOptionsApiKey,
      authDomain: firebaseOptionsAuthDomain,
      projectId: firebaseOptionsProjectId,
      storageBucket: firebaseOptionsStorageBucket,
      messagingSenderId: firebaseOptionsMessagingSenderId,
      appId: firebaseOptionsAppId,
      measurementId: firebaseOptionsMeasurementId,
    ),
  );
  usePathUrlStrategy();
  runApp(const PlaygroundApp());
}

class PlaygroundApp extends StatelessWidget {
  const PlaygroundApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider<LocaleProvider>(
          create: (context) => LocaleProvider(),
        ),
      ],
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Playground',
          locale: Provider.of<LocaleProvider>(context).locale ?? const Locale.fromSubtags(languageCode: 'en'),
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: Locales.languages,
          themeMode: ThemeMode.dark,
          theme: Provider.of<ThemeProvider>(context).themeOption,
          darkTheme: PlaygroundTheme.dark,
          home: HomeScreen(),
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(displayScaleFactor),
              ),
              child: widget ?? const SizedBox.shrink(),
            );
          },
          scrollBehavior: _CustomScrollBehavior(),
        );
      },
    );
  }
}

class _CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => <PointerDeviceKind>{
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.stylus,
        PointerDeviceKind.invertedStylus,
        PointerDeviceKind.unknown,
      };
}
