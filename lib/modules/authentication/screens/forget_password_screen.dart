import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playground/core/themes/styles.dart';
import 'package:playground/modules/authentication/controllers/sign_in_controller.dart';

class ForgetPasswordScreen extends StatelessWidget {
  const ForgetPasswordScreen({super.key});

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
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
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
                    'Recover Password',
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
          ],
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}
