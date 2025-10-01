import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wingai/core/themes/styles.dart';
import 'package:wingai/modules/authentication/controllers/sign_in_controller.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: AppColors.chatBackgroundColor,
      body: Center(
        child: isSmallScreen
            ? const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _Logo(),
                  _FormContent(),
                ],
              )
            : Container(
                padding: const EdgeInsets.all(32.0),
                constraints: const BoxConstraints(maxWidth: 800),
                child: const Row(
                  children: [
                    Expanded(
                      child: _Logo(),
                    ),
                    Expanded(
                      child: Center(
                        child: _FormContent(),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: isSmallScreen ? 100 : 200,
          width: isSmallScreen ? 100 : 200,
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(
                isSmallScreen ? 50 : 100,
              ),
            ),
            child: Image.asset(
              "assets/images/rnd_logo.jpeg",
              fit: BoxFit.contain,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Welcome to Wing-AI",
            textAlign: TextAlign.center,
            style: isSmallScreen ? Theme.of(context).textTheme.titleMedium : Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ],
    );
  }
}

class _FormContent extends GetView<SingInController> {
  const _FormContent();

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: Form(
        key: controller.formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: controller.emailCon,
              validator: (value) {
                // add email validation
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }

                bool emailValid = RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                ).hasMatch(value);
                if (!emailValid) {
                  return 'Please enter a valid email';
                }

                return null;
              },
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                hintStyle: Theme.of(context).textTheme.bodySmall,
                prefixIcon: const Icon(Icons.email_outlined),
                border: const OutlineInputBorder(),
              ),
            ),
            _gap(),
            Obx(
              () => TextFormField(
                controller: controller.pwdCon,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }

                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
                obscureText: !controller.isPasswordVisible.value,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Enter your password',
                  hintStyle: Theme.of(context).textTheme.bodySmall,
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      controller.isPasswordVisible.value ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      controller.isPasswordVisible.value = !controller.isPasswordVisible.value;
                    },
                  ),
                ),
              ),
            ),
            _gap(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Forget Password",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              ],
            ),
            _gap(),
            ElevatedButton(
              onPressed: () {
                controller.authController.signInWithGoogle(context, () {
                  // initChatSession();
                }, (e) {}, () {});
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.only(
                  left: 6,
                ),
                minimumSize: const Size(200, 50),
                backgroundColor: Colors.white,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Image.asset(
                      'assets/images/google_icon.png',
                      width: 30,
                      height: 30,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'Continue With Google',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.darkBorderColor),
                    ),
                  ),
                ],
              ),
            ),
            _gap(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(
                    'Sign in',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                onPressed: () {
                  if (controller.formKey.currentState?.validate() ?? false) {
                    controller.signIn();
                  }
                },
              ),
            ),
            _gap(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Dont have an account?"),
                TextButton(
                  onPressed: () {
                    Get.toNamed('/sign_up');
                  },
                  child: Text(
                    "Sign Up",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.ticketClose),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
