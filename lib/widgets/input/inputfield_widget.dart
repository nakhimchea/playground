import 'package:flutter/material.dart';
import 'package:wingai/core/themes/styles.dart';

class InputFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final Widget? leading;
  final Widget? trailing;
  final bool password;
  final FocusNode? focusNode;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final void Function()? trailingTapped;
  final InputDecoration? decoration;
  final TextInputType? keyboardType;

  final circularBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
  );

  InputFieldWidget({
    super.key,
    required this.controller,
    this.placeholder = '',
    this.leading,
    this.trailing,
    this.trailingTapped,
    this.validator,
    this.password = false,
    this.focusNode,
    this.onChanged,
    this.decoration,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      style: const TextStyle(
        height: 1,
        color: AppColors.textBoxHint,
      ),
      obscureText: password,
      validator: validator,
      onChanged: onChanged,
      focusNode: focusNode,
      keyboardType: keyboardType,
      decoration: decoration ??
          InputDecoration(
            hintText: placeholder,
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            filled: true,
            fillColor: AppColors.surface,
            hintStyle: const TextStyle(
              color: AppColors.textBoxHint,
            ),

            prefixIcon: leading,
            prefixIconColor: AppColors.textBoxHint,
            suffixIconColor: AppColors.textBoxHint,
            suffixIcon: trailing != null
                ? GestureDetector(
                    onTap: trailingTapped,
                    child: trailing,
                  )
                : null,
            border: circularBorder.copyWith(
              borderSide: const BorderSide(
                color: AppColors.disableText,
              ),
            ),
            // errorBorder: circularBorder.copyWith(
            //   borderSide: BorderSide(color: Theme.of(context).colorScheme.onError),
            // ),
            focusedBorder: circularBorder.copyWith(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            enabledBorder: circularBorder.copyWith(
              borderSide: const BorderSide(
                color: AppColors.disableText,
              ),
            ),
          ),
    );
  }
}
