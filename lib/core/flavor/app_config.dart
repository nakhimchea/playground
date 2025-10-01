import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:wingbrain/core/flavor/options.dart';
// import 'package:wingbrain/main.dart';
// import 'package:wingchat/core/core.dart';
// import 'package:wingchat/core/resources/language/locales.g.dart';
// import 'package:wingchat/flavor/options.dart';
// import 'package:wingchat/main.dart' show customPrint, dismissFlutter;

enum EnvironmentType { dev, prod }

/// Call configure() to init the environment
class AppConfig {
  AppConfig._();

  // Version version = Version.parse('1.0.0+1');
  final String _xSecretApi = '';
  String get xSecretApi => _xSecretApi;

  // contants to call native config
  static const String kChannelName = 'flavor';
  static const String kMethodName = 'getFlavor';

  static final _instance = AppConfig._();
  static AppConfig get shared => _instance;

  // Use for checking method channel invokes
  bool get isStandalone => (const String.fromEnvironment('MODE')) == 'standalone';

  late EnvironmentType _env;
  EnvironmentType get env => _env;
  void setEnv(EnvironmentType value) {
    _env = value;
    _setBaseUrl();
    _getAppVersion();
  }

//https://jsonplaceholder.typicode.com
  String? _baseUrl;
  String get baseUrl => '$_baseUrl/'; //'$_baseUrl/api/v1';

  late String _language;
  String get language => _language;

  bool get isDebugEnabled => kDebugMode || [EnvironmentType.dev].contains(_env);

  Function(BuildContext context, bool isMaintenance)? _onNavigateToVOIP;
  Function(BuildContext context, bool isMaintenance)? get onNavigateToVOIP => _onNavigateToVOIP;
  bool get isVOIPEnabled => _onNavigateToVOIP != null;

  Future<void> configureStandalone() async {
    // try {
    //   const channel = MethodChannel(kChannelName);
    //   final flavor = await channel.invokeMethod(kMethodName);

    //   if (flavor != null && flavor is String) {
    //     final envString = flavor.toString().toUpperCase();
    //     setEnv(mapEnvironmentType(envString));
    //     setLanguage('EN');

    //     customPrint('════ Starting with flavor: $flavor, env: $_env ════');
    //     return;
    //   }

    //   customPrint('════ Unable to get Flavor String ════ ');
    // } catch (e) {
    //   customPrint('════ Failed to start flavor: $e ════ ');
    // }

    setEnv(EnvironmentType.dev);
    // setLanguage('EN');
  }

  Future<void> configureEmbedded() async {
    // var result = await MethodChannelServiceMethods.requestEnvironment();

    // var data = jsonDecode(result);
    // final language = data['language'];
    // final env = data['env'];

    // setEnv(mapEnvironmentType(env));
    // setLanguage(language);

    // await EcoModuleNativeFontLoader.shared.initAllFontVariants(_language);

    // customPrint('════ Configured Embedded: $_env, $_language ════');
  }

  void configureCallbacks({
    Function(BuildContext context, bool isMaintenance)? onNavigateToVOIP,
  }) {
    _onNavigateToVOIP = onNavigateToVOIP;
  }

  void _setBaseUrl() {
    _baseUrl = 'https://api.openai.com/v1/chat/completions';
    // switch (_env) {
    //   case EnvironmentType.dev:
    //     _baseUrl = 'https://api.openai.com/v1/chat/completions'; //AppConfigSecret.devBaseUrl;
    //     // _xSecretApi = AppConfigSecret.dev;
    //     break;
    //   case EnvironmentType.prod:
    //     _baseUrl = 'https://api.openai.com/v1/chat/completions';
    //     // _baseUrl = AppConfigSecret.prodBaseUrl;
    //     // _xSecretApi = AppConfigSecret.production;
    //     break;
    // }
  }

  void setLanguage(String value) => _language = value.toUpperCase();

  String get lowercasedLangCode => languageLocale.languageCode.toLowerCase();
  String get defaultLowercasedLangCode => 'en';

  Locale get languageLocale => mapLanguageCode(language);

  String get lowercasedEnglishCode => 'en';
  String get lowercasedKhmerCode => 'km';
  String get lowercasedChineseCode => 'zh';

  void _getAppVersion() async {
    // try {
    //   final content = await rootBundle.loadString('${AssetPath.basePath}/version.txt');
    //   version = Version.parse(content.isNotEmpty ? content.trim() : '0.0.0');

    //   // Purposefully print for developers to quickly verify that it is the latest app version
    //   // ignore: avoid_print
    //   print('Launching WingChat Version: ${version.toString()}');
    // } catch (exception, trace) {
    //   exceptionHandler(exception, trace, alert: false);
    // }
  }

  bool hasAppForceUpdate() {
    // final minAppVersion = Version.parse(AppConstants.appUpdateInfoMiniAppVersion);
    // customPrint('Has Force Update: ${version < minAppVersion}');
    // return !AppConfig.shared.isStandalone && version < minAppVersion;
    return false;
  }

  void checkAppForceUpdate() async {
    try {
      if (!hasAppForceUpdate()) return;

      // AlertDialogManager.showDefaultMessage(
      //   titleAsset: AssetPathEnum.updateAlert,
      //   title: LocaleKeys.new_version_available.tr,
      //   content: LocaleKeys.there_are_new_features_available_please_update_your_app_to_continue.tr,
      //   titleAssetSize: const Size(39 + 5, 36 + 5),
      //   titleAssetPadding: 0,
      //   titleAssetBackground: Colors.transparent,
      //   bottomSpaceAssetToTitle: 12,
      //   spaceTitleToContent: 6,
      //   isDismissible: false,
      //   titleTextStyle: AppTextStyle.halfMidSemiBoldTextStyle,
      //   actions: [
      //     DialogWidgetAction(
      //       text: LocaleKeys.exit.tr,
      //       style: AppTextStyle.halfMidGreySemiBoldTextStyle,
      //       onTap: () {
      //         Get.back();
      //         Future.microtask(() => dismissFlutter());
      //       },
      //     ),
      //     DialogWidgetAction(
      //       text: LocaleKeys.update_now.tr,
      //       style: AppTextStyle.halfMidBlueSemiBoldTextStyle,
      //       onTap: () => UrlLauncherManager.launchStoreLink(),
      //     ),
      //   ],
      // );
    } catch (exception, trace) {
      log(trace.toString());
      // exceptionHandler(exception, trace, alert: false);
    }
  }
}

EnvironmentType mapEnvironmentType(String type) {
  // switch (type.toUpperCase()) {
  //   case 'DEV':
  //   case 'STAGE':
  //   case 'UAT':
  //     return EnvironmentType.dev;
  //   case 'PVT':
  //   case 'PROD':
  //     return EnvironmentType.prod;
  //   default:
  return EnvironmentType.dev;
  // }
}

Locale mapLanguageCode(String lang) {
  switch (lang.toUpperCase()) {
    case 'KH':
    case 'KM':
      return const Locale('KM', 'KH');
    case 'EN':
      return const Locale('EN', 'US');
    case 'CH':
    case 'ZH':
      return const Locale('ZH', 'CH');
    default:
      return const Locale('EN', 'US');
  }
}
