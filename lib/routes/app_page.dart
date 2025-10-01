import 'package:get/route_manager.dart';
import 'package:playground/modules/authentication/bindings/sign_in_binding.dart';
import 'package:playground/modules/authentication/bindings/sign_up_binding.dart';
import 'package:playground/modules/authentication/screens/sign_in_screen.dart';
import 'package:playground/modules/authentication/screens/sign_up_screen.dart';
import 'package:playground/modules/chat/binding/chat_binding.dart';
import 'package:playground/modules/splash/splash.dart';

import '../modules/chat/screens/chat_screen.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      // binding: ChatBinding(),
      name: '/',
      page: () => const SplashScreen(),
    ),
    GetPage(
      binding: ChatBinding(),
      name: '/chat',
      page: () => ChatScreen(),
    ),
    GetPage(
      binding: SignInBinding(),
      name: '/sign_in',
      page: () => const SignInScreen(),
    ),
    GetPage(
      binding: SignUpBinding(),
      name: '/sign_up',
      page: () => const SignUpScreen(),
    ),
  ];
}
