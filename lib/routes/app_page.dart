import 'package:get/route_manager.dart';
import 'package:wingai/modules/authentication/bindings/sign_in_binding.dart';
import 'package:wingai/modules/authentication/bindings/sign_up_binding.dart';
import 'package:wingai/modules/authentication/screens/sign_in_screen.dart';
import 'package:wingai/modules/authentication/screens/sign_up_screen.dart';
import 'package:wingai/modules/chat/binding/chat_binding.dart';
import 'package:wingai/modules/splash/splash.dart';

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
