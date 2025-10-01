// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:wingbrain/core/extensions/int.dart';
// import 'package:wingbrain/core/themes/styles.dart';
// // import 'package:wingchat/core/core.dart';
// // import 'package:wingchat/core/extensions/extensions.dart';

// class SnackbarManager {
//   SnackbarManager._();

//   static void showDefaultMessage(
//     String message, {
//     int duration = 2000,
//     bool isSuccess = true,
//   }) {
//     final context = Get.context;
//     if (context == null) return;

//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       behavior: SnackBarBehavior.floating,
//       margin: const EdgeInsets.all(16),
//       padding: const EdgeInsets.symmetric(
//         vertical: 12,
//         horizontal: 14,
//       ),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       duration: Duration(milliseconds: duration),
//       backgroundColor: AppColors.snackbarBackground,
//       content: Row(
//         children: [
//           Container(
//             width: 20,
//             height: 20,
//             decoration: BoxDecoration(
//               color: isSuccess ? AppColors.snackbarGreen : AppColors.snackbarRed,
//               shape: BoxShape.circle,
//             ),
//             alignment: Alignment.center,
//             child: Icon(
//               isSuccess ? Icons.check : Icons.close,
//               color: AppColors.white,
//               size: 12,
//             ),
//           ),
//           12.width,
//           Text(
//             message,
//             style: const TextStyle(
//               color: AppColors.white,
//               fontSize: 12,
//               // fontWeight: AppStyle._regular,
//             ), //AppTextStyle.smallWhiteRegularTextStyle,
//           ),
//         ],
//       ),
//     ));
//   }
// }
