import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playground/modules/authentication/controllers/authentication_controller.dart';

class SingInController extends GetxController {
  final authController = Get.find<AuthenticationController>();
  final RxBool isPasswordVisible = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailCon = TextEditingController();
  TextEditingController pwdCon = TextEditingController();

  Future<void> signIn() async {
    authController.emailController = emailCon;
    authController.passwordController = pwdCon;
    authController.signInWithEmailPassword();
  }

  void signInWithGoogleSignIn(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {} catch (e) {
      Navigator.of(context).pop(); // close dialog
    }
  }
}
