// import 'package:commonvoice/core/controllers/authentication.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:wingai/core/themes/styles.dart';
import 'package:wingai/modules/authentication/controllers/authentication_controller.dart';

class SplashScreen extends GetView<AuthenticationController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.chatBackgroundColor,
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.chatBackgroundColor,
        ),
        child: Center(
            child: Lottie.asset(
          'assets/json/logo.json',
          height: 150,
          animate: true,
          fit: BoxFit.contain,
          onLoaded: (composition) {
            controller.splashScreenCheckExistingUser();
          },
        )),
      ),
    );
  }
}
