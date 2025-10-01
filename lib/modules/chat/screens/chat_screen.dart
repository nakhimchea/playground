import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playground/core/helpers/convert.dart';
import 'package:playground/core/themes/styles.dart';
import 'package:playground/modules/chat/controllers/chat_controller.dart';
import 'package:playground/modules/chat/controllers/layout_controller.dart';
import 'package:playground/modules/chat/widgets/chat_drawer.dart';
import 'package:playground/modules/chat/widgets/chat_section.dart';
import 'package:playground/modules/chat/widgets/circle_local_asset.dart';
import 'package:playground/modules/chat/widgets/icon_image.dart';
import 'package:playground/modules/chat/widgets/sub_ai_model_item.dart';
import 'package:playground/widgets/popup_menu_widget.dart';

class ChatScreen extends GetView<ChatController> {
  final layoutController = Get.find<LayoutController>();

  ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool currentIsMobile = layoutController.isMobile(constraints.maxWidth);
        if (currentIsMobile != layoutController.useMobileLayout.value) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            layoutController.useMobileLayout.value = currentIsMobile;
            layoutController.isSidebarOpen.value = layoutController.useMobileLayout.value;
          });
        }
        return Row(
          children: [
            Obx(() {
              if (!layoutController.useMobileLayout.value && layoutController.isSidebarOpen.value) {
                return ChatDrawer(
                  permanentlyDisplay: true,
                  onMenuPressed: layoutController.toggleSidebar,
                  chatController: controller,
                );
              }
              return const SizedBox.shrink();
            }),
            Expanded(
              child: Obx(
                () => Scaffold(
                  key: layoutController.scaffoldKey,
                  drawerScrimColor: Colors.transparent,
                  extendBodyBehindAppBar: true,
                  appBar: AppBar(
                    elevation: 0,
                    title: Row(
                      children: [
                        Flexible(
                          child: Obx(
                            () => PopupMenuWidget(
                              initValue: controller.selectedModelIndex.value,
                              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                              items: List.generate(controller.aiModels.length, (index) {
                                var model = controller.aiModels[index];
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleLocalAsset(
                                      localAssetPath: model['image'],
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      model['title'],
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                    Flexible(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: List.generate(
                                          model['subFetures'].length,
                                          (index) {
                                            var subFeature = model['subFetures'][index];
                                            return Flexible(
                                              child: SubAiModelItem(
                                                title: subFeature,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                              offset: const Offset(5, 30),
                              onSelected: (value) {
                                controller.switchAIModel(value);
                              },
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Obx(
                                      () => Text(
                                        controller.selectedModelName.value,
                                        style: Theme.of(context).textTheme.titleMedium,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 2,
                                  ),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () {},
                            icon: const Icon(
                              Icons.add,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: AppColors.chatBackgroundColor,
                    centerTitle: false,
                    leading: layoutController.useMobileLayout.value
                        ? Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                              child: IconImage(
                                imagePath: 'assets/images/menu-bar.png',
                                onTap: () => layoutController.scaffoldKey.currentState?.openDrawer(),
                                size: 20.0,
                              ),
                            ),
                          )
                        : (!layoutController.isSidebarOpen.value
                            ? Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                                  child: IconImage(
                                    imagePath: 'assets/images/menu-bar.png',
                                    onTap: layoutController.toggleSidebar,
                                    size: 20.0,
                                  ),
                                ),
                              )
                            // IconButton(
                            //     icon: const Icon(
                            //       Icons.subject,
                            //       color: AppColors.lightGreyIconColor,
                            //     ),
                            //     onPressed: layoutController.toggleSidebar,
                            //   )
                            : null),
                    actions: [
                      // Flexible(
                      //   child: IconButton(
                      //     onPressed: () {},
                      //     icon: const Icon(
                      //       Icons.more_horiz,
                      //       size: 18,
                      //       color: AppColors.lightGreyIconColor,
                      //     ),
                      //   ),
                      // ),
                      Flexible(
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.tune,
                            size: 18,
                            color: AppColors.lightGreyIconColor,
                          ),
                        ),
                      ),
                      Flexible(
                        child: PopupMenuWidget(
                          items: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.settings,
                                  color: AppColors.lightGreyIconColor,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Setting",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.architecture,
                                  color: AppColors.lightGreyIconColor,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Archived Chats",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.logout,
                                  color: AppColors.lightGreyIconColor,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Sign Out",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                )
                              ],
                            ),
                          ],
                          offset: const Offset(10, 35),
                          onSelected: (value) {
                            if (value == 1) {
                            } else if (value == 2) {
                              controller.signOut();
                            }
                          },
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: Colors.blue,
                            child: Obx(
                              () => Text(
                                capitalizeFirstLetter(controller.topicController.email.value),
                                style: Theme.of(context).textTheme.bodyLarge!,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      )
                    ],
                  ),
                  drawer: layoutController.useMobileLayout.value
                      ? ChatDrawer(
                          permanentlyDisplay: false,
                          onMenuPressed: layoutController.toggleSidebar,
                          chatController: controller,
                        )
                      : null,
                  body: const SafeArea(
                    child: Chat(),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
