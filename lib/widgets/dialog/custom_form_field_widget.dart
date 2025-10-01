import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wingai/core/themes/metrics.dart';
import 'package:wingai/core/themes/styles.dart';
import 'package:wingai/modules/chat/widgets/icon_image.dart';
import 'package:wingai/widgets/button/button_widget.dart';

import '../input/inputfield_widget.dart';

class CustomDialogFormFieldWidget extends StatelessWidget {
  final String title;
  final void Function()? onClose;
  final TextEditingController controller;
  final void Function()? onSubmit;

  const CustomDialogFormFieldWidget({
    super.key,
    this.onClose,
    required this.title,
    this.onSubmit,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 350,
          minWidth: 350,
        ),
        child: Container(
          decoration:
              const BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.all(Radius.circular(18))),
          padding: EdgeInsets.all(Metrics.instance.defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  const IconImage(
                    imagePath: 'assets/images/title.png',
                    onTap: null,
                    size: 34.0,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.white,
                        ),
                  ),
                  const SizedBox(height: 16),
                  InputFieldWidget(
                    controller: controller,
                    placeholder: 'Conversation Title',
                  ),
                ],
              ),
              SizedBox(height: Metrics.instance.spacing24),
              Row(
                children: [
                  Expanded(
                    child: ButtonWidget(
                      buttonType: ButtonType.labelButton,
                      primary: false,
                      textcolor: Colors.grey,
                      label: "Close",
                      onPressed: () {
                        Get.close(1);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: ButtonWidget(
                      buttonType: ButtonType.fill,
                      primary: true,
                      label: "Submit",
                      textcolor: Colors.white,
                      onPressed: onSubmit,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
