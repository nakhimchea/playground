import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wingai/modules/authentication/controllers/authentication_controller.dart';

class SignUpController extends GetxController {
  final authController = Get.find<AuthenticationController>();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;

  TextEditingController signUpEmail = TextEditingController();
  TextEditingController signUpPwd = TextEditingController();
  TextEditingController signUpConfirmPwd = TextEditingController();

  Future<void> signUp() async {
    authController.signUpemailController = signUpEmail;
    authController.signUppasswordController = signUpPwd;

    authController.signUpWithEmailPassword();
  }
}
