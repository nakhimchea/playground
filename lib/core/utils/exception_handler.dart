import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wingai/core/flavor/app_config.dart';
import 'package:wingai/widgets/dialog/alert/custom_dialog_widget.dart';
import 'package:wingai/widgets/dialog/alert/dialog_manager.dart';

import '../constants/asset_path.dart';

List<Map<String, dynamic>> exceptions = [];

Future<dynamic> exceptionHandler(
  dynamic exception,
  StackTrace trace, {
  bool alert = true,
  bool log = true,
  String? alertTitleText,
  String? alertContentText,
  AssetPathEnum? titleAsset,
  Size? titleAssetSize,
  List<DialogWidgetAction>? alertActions,
  VoidCallback? onDefaultRetry,
}) async {
  // customPrint(exception.toString());
  // customPrint(trace.toString());

  if (AppConfig.shared.isDebugEnabled) {
    if (exceptions.length > 50) exceptions.clear();
    exceptions.add({'exception': exception, 'trace': trace});
  }

  if (log) {
    // FirebaseCrashlyticsService.shared.setErrorLog(exception, trace);
  }

  if (alert) {
    return AlertDialogManager.showRequestExceptionMessage(
      exception,
      title: alertTitleText,
      contentText: alertContentText,
      titleAsset: titleAsset ?? AssetPathEnum.assetException,
      titleAssetSize: titleAssetSize ?? const Size(106, 52),
      actions: alertActions ??
          (onDefaultRetry != null
              ? [
                  DialogWidgetAction(
                    text: 'Go Back', // LocaleKeys.go_back.tr,
                    onTap: () => Get.back(),
                    // style: AppTextStyle.normalSecondarySemiBoldTextStyle,
                  ),
                  DialogWidgetAction(
                    text: 'Retry', //LocaleKeys.retry.tr,
                    onTap: () {
                      Get.back(result: true);
                      onDefaultRetry();
                    },
                  ),
                ]
              : null),
    );
  }
}
