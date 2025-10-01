import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playground/core/constants/asset_path.dart';
import 'package:playground/core/extensions/extensions.dart';
import 'package:playground/core/themes/styles.dart';
import 'package:playground/widgets/base/divider.dart';
import 'package:playground/widgets/image/cached_network_image.dart';
// import 'package:wingbrain/core/constants/asset_path.dart';
// import 'package:wingbrain/core/extensions/extensions.dart';
// import 'package:wingbrain/core/themes/styles.dart';
// import 'package:wingbrain/widgets/base/divider.dart';
// import 'package:wingbrain/widgets/image/cached_network_image.dart';
// import 'package:wingchat/core/core.dart';
// import 'package:wingchat/core/extensions/extensions.dart';
// import 'package:wingchat/core/resources/language/locales.g.dart';
// import 'package:wingchat/core/resources/resources.dart';

class DialogWidgetAction {
  final String text;
  final TextStyle style;
  final VoidCallback onTap;

  DialogWidgetAction({
    required this.onTap,
    String? text,
    TextStyle? style,
  })  : text = text ?? 'Ok',
        style = style ?? const TextStyle(color: AppColors.blue, fontSize: 14, fontWeight: FontWeight.bold);
}

/// Returns true, when default "Continue" button is tapped
/// false otherwise, when tap on dismiss area or close button
/// If want to handle onDismiss when not close via "Continue" button,
/// just await check for true (Check splash/view.dart)
class CustomDialogWidget extends StatelessWidget {
  CustomDialogWidget({
    super.key,
    required this.title,
    required this.content,
    this.titleAsset,
    this.titleAssetSize,
    this.titleAssetBackground,
    List<DialogWidgetAction>? actions,
    int? spaceAssetToTitle = 24,
    int? spaceTitleToContent = 14,
    double? bottomSpaceAssetToTitle,
    double? titleAssetPadding,
    TextStyle? titleTextStyle,
  })  : actions = actions ?? [DialogWidgetAction(onTap: () => Get.back(result: true))],
        spaceAssetToTitle = spaceAssetToTitle ?? 24,
        spaceTitleToContent = spaceTitleToContent ?? 14,
        bottomSpaceAssetToTitle = bottomSpaceAssetToTitle ?? 14,
        titleAssetPadding = titleAssetPadding ?? 12,
        titleTextStyle = titleTextStyle ??
            const TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.w600 //AppStyle._semiBold,
                ), //AppTextStyle.midSemiBoldTextStyle,
        assert(titleAsset != null ? titleAssetSize != null : true, 'AssetSize must be provided');

  final String title;
  final AssetPathEnum? titleAsset;
  final Size? titleAssetSize;
  final Color? titleAssetBackground;
  final String content;
  final List<DialogWidgetAction> actions;
  final int spaceAssetToTitle;
  final int spaceTitleToContent;
  final double bottomSpaceAssetToTitle;
  final double titleAssetPadding;
  final TextStyle titleTextStyle;

  static Size get defaultTitleAssetSize => const Size(24, 24);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 350, minWidth: 250),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 14.height,
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 18),
            //   child: Row(
            //     children: [
            //       const Spacer(),
            //       InkWell(
            //         borderRadius: BorderRadius.circular(100),
            //         onTap: () => Get.back(),
            //         child: Container(
            //           padding: const EdgeInsets.all(4.5),
            //           decoration: const BoxDecoration(
            //             color: AppColor.dividerColor,
            //             shape: BoxShape.circle,
            //           ),
            //           child: const Icon(
            //             Icons.close,
            //             color: AppColor.darkGrey,
            //             size: 18,
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            spaceAssetToTitle.height,
            if (titleAsset != null)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  18,
                  0,
                  18,
                  bottomSpaceAssetToTitle.toDouble(),
                ),
                child: Container(
                  padding: EdgeInsets.all(titleAssetPadding),
                  decoration: BoxDecoration(
                    color: titleAssetBackground ?? AppColors.blue.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: CustomCachedAssetImage(
                    titleAsset!,
                    width: titleAssetSize?.width,
                    height: titleAssetSize?.height,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: titleTextStyle,
                    ),
                  ),
                ],
              ),
            ),
            spaceTitleToContent.height,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Text(
                content,
                style: const TextStyle(
                  color: Color(0xFF66798C),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            24.height,
            const LightGreyDivider(),
            SizedBox(
              height: 52,
              child: Row(
                children: List.generate(
                  actions.length,
                  (index) {
                    final action = actions[index];
                    final isLast = index + 1 == actions.length;

                    return Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: action.onTap,
                              child: Container(
                                color: Colors.transparent,
                                child: Center(
                                  child: Text(
                                    action.text,
                                    style: action.style,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (!isLast) const LightGreyVerticalDivider(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
