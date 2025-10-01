import 'dart:developer';

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playground/core/extensions/extensions.dart';
import 'package:playground/core/helpers/response.dart';
import 'package:playground/core/themes/styles.dart';
import 'package:playground/widgets/image/cached_network_image.dart';

import '../../../core/constants/asset_path.dart';
import '../../../core/flavor/app_config.dart';
import 'custom_dialog_widget.dart';

class AlertDialogManager {
  AlertDialogManager._();

  static Future<dynamic> showDefaultMessage({
    required String title,
    required String content,
    List<DialogWidgetAction>? actions,
    AssetPathEnum? titleAsset,
    Color? titleAssetBackground,
    Size? titleAssetSize,
    VoidCallback? onActionTap,
    bool isDismissible = true,
    int? spaceAssetToTitle,
    int? spaceTitleToContent,
    double? titleAssetPadding,
    double? bottomSpaceAssetToTitle,
    TextStyle? titleTextStyle,
  }) {
    while (Get.isOverlaysOpen) {
      Get.back(closeOverlays: true);
    }

    final context = Get.context;
    if (context == null) return Future.value(null);

    return Get.dialog(
      PopScope(
        canPop: isDismissible,
        child: CustomDialogWidget(
          title: title,
          titleAsset: titleAsset,
          titleAssetSize: titleAssetSize,
          titleAssetBackground: titleAssetBackground,
          content: content,
          actions: actions,
          spaceAssetToTitle: spaceAssetToTitle,
          spaceTitleToContent: spaceTitleToContent,
          titleAssetPadding: titleAssetPadding,
          bottomSpaceAssetToTitle: bottomSpaceAssetToTitle,
          titleTextStyle: titleTextStyle,
        ),
      ),
      barrierDismissible: isDismissible,
    );
  }

  static Future<dynamic> showConfirmation({
    required String title,
    required String content,
    required DialogWidgetAction action,
  }) {
    return AlertDialogManager.showDefaultMessage(
      title: title,
      content: content,
      actions: [
        DialogWidgetAction(
          onTap: () => Get.back(),
          text: 'Cancel',
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 14,
            // fontWeight: AppStyle._semiBold,
          ), //AppTextStyle.normalGreySemiBoldTextStyle,
        ),
        action,
      ],
    );
  }

  static bool isShowingNoInternet = false;

  static Future<dynamic> showNoInternetConnection({
    bool barrierDismissible = false,
  }) async {
    while (Get.isOverlaysOpen) {
      Get.back(closeOverlays: true);
    }

    final context = Get.overlayContext;
    if (context == null) return Future.value(null);

    isShowingNoInternet = true;

    await Get.dialog(
      PopScope(
        canPop: false,
        child: Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 16),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 15,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CustomCachedAssetImage(
                  AssetPathEnum.wifiSlash,
                  height: 36,
                  width: 36,
                ),
                16.width,
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Lost Connection', // LocaleKeys.connection_lost.tr,
                        textAlign: TextAlign.left,
                        // style: AppTextStyle.normalSemiBoldTextStyle,
                      ),
                      5.height,
                      const Text(
                        'Please check your internet connection', // LocaleKeys.please_check_your_internet_connection.tr,
                        // style: AppTextStyle.normalRegularTextStyle.copyWith(
                        //   fontSize: 12,
                        // ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierDismissible: barrierDismissible,
    );

    isShowingNoInternet = false;
  }

  static Future<dynamic> showRequestExceptionMessage(
    dynamic exception, {
    String? title,
    String? contentText,
    List<DialogWidgetAction>? actions,
    AssetPathEnum? titleAsset,
    Size? titleAssetSize,
  }) async {
    final context = Get.context;
    if (context == null) return;

    final lang = AppConfig.shared.language.toLowerCase();

    String? title;
    String? content = contentText;

    if (exception is dio.DioError) {
      log(lang.toString());
      content ??= getResponseMessage(exception, lang: lang);
    }

    return showDefaultMessage(
      title: title ?? 'We appologize for the incovenience', // LocaleKeys.we_apologize_for_the_inconvenience.tr,
      content: content ?? 'We are working on fixing the problem', //LocaleKeys.we_are_working_on_fixing_the_problem.tr,
      titleAsset: titleAsset,
      titleAssetSize: titleAssetSize,
      actions: actions,
    );
  }
}
