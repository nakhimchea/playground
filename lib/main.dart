import 'dart:async';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logging/logging.dart';
import 'package:toastification/toastification.dart';
import 'package:wingai/core/flavor/app_config.dart';
import 'package:wingai/core/llibraries/connectivity_plus.dart';
import 'package:wingai/core/service/api/connect.dart';
import 'package:wingai/core/service/firebase/api.service.dart';
import 'package:wingai/core/themes/styles.dart';
import 'package:wingai/core/utils/exception_handler.dart';
import 'package:wingai/modules/authentication/controllers/authentication_controller.dart';

import 'routes/app_page.dart';

void main({
  Function(BuildContext context, bool isMaintenance)? onNavigateToVOIP,
}) async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initEnvironment();
    await initServices();
    Logger.root.level = Level.ALL;

    if (AppConfig.shared.isDebugEnabled) {
      Logger.root.level = Level.ALL;
      // await VideoCompress.setLogLevel(Level.WARNING.value);
      // Logger.root.onRecord.listen(customPrint);
    } else {
      // await VideoCompress.setLogLevel(Level.OFF.value);
      // Logger.root.level = Level.OFF;
    }

    runApp(const DemoApp());
  }, (exception, trace) {
    exceptionHandler(exception, trace, alert: false);
  });
}

Future<void> initEnvironment() async {
  // EcoModuleNativeFontLoader.shared.setIsStandalone(() => AppConfig.shared.isStandalone);
  // EcoModuleNativeFontLoader.shared.setOnPrint(customPrint);

  // if (!AppConfig.shared.isStandalone) {
  //   await AppConfig.shared.configureEmbedded();
  // } else {
  //   await AppConfig.shared.configureStandalone();
  // AppConfig.shared.setLanguage('EN');
  // }
  await AppConfig.shared.configureStandalone();
  AppConfig.shared.setLanguage('EN');
}

Future<void> initServices() async {
  try {
    if (kIsWeb) {
      const firebaseConfig = FirebaseOptions(
        apiKey: "AIzaSyA3j87EGcBgumeGXzzGRYRSRoPz2tju9Is",
        authDomain: "voicebot-assistant-dev.firebaseapp.com",
        projectId: "voicebot-assistant-dev",
        storageBucket: "voicebot-assistant-dev.appspot.com",
        messagingSenderId: "805568492128",
        appId: "1:805568492128:web:ae30876942485592d7c905",
        measurementId: "G-9CG3Q2RPCV",
      );
      await Firebase.initializeApp(
        options: firebaseConfig,
      );
    } else {
      await Firebase.initializeApp();
    }

    if (!kIsWeb) {
      if (kDebugMode) {
        await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
      } else {
        FlutterError.onError = (errorDetail) {
          FirebaseCrashlytics.instance.recordFlutterError(errorDetail);
        };
      }
    }
    // Setup Get and Storage
    await GetStorage.init();
    Get.put<ApiService>(ApiService());
    Get.put(FirebaseService());
    Get.put<AuthenticationController>(AuthenticationController(), permanent: true);
    ConnectivityPlusManager.shared;
  } catch (exception, trace) {
    log(trace.toString());
    exceptionHandler(exception, trace, alert: false);
  }
}

class DemoApp extends StatelessWidget {
  const DemoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: GetMaterialApp(
        title: 'Wing AI',
        initialRoute: '/',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.light,
        theme: AppTheme.lightTheme,
        getPages: AppPages.pages,
      ),
    );
  }
}
