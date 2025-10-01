import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:playground/core/helpers/convert.dart';
import 'package:playground/core/themes/styles.dart';
import 'package:playground/modules/chat/controllers/chat_controller.dart';
import 'package:playground/modules/chat/widgets/chat_topic.dart';
import 'package:playground/modules/chat/widgets/custom_expansion.dart';
import 'package:playground/modules/chat/widgets/icon_image.dart';
import 'package:playground/widgets/popup_menu_widget.dart';

class ChatDrawer extends StatelessWidget {
  final VoidCallback onMenuPressed;
  final bool permanentlyDisplay;
  final ChatController chatController;

  const ChatDrawer({
    super.key,
    required this.onMenuPressed,
    required this.permanentlyDisplay,
    required this.chatController,
  });

  @override
  Widget build(BuildContext context) {
    final controller = chatController.topicController;
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      clipBehavior: Clip.none,
      child: Container(
        color: AppColors.chatSideBarBackgroundColor,
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    children: [
                      IconImage(
                        imagePath: 'assets/images/menu-bar.png',
                        onTap: () {
                          if (!permanentlyDisplay) {
                            Navigator.of(context).pop();
                          }
                          onMenuPressed();
                        },
                        size: 20.0,
                      ),
                      const SizedBox(width: 8),
                      // const CircleAvatar(radius: 15, backgroundColor: Colors.blue),
                      ClipRRect(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(15),
                        ),
                        child: Image.asset(
                          width: 25,
                          height: 25,
                          "assets/images/rnd_logo.jpeg",
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "New Chat",
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const Spacer(),
                      IconImage(
                        imagePath: 'assets/images/edit-button.png',
                        onTap: () {
                          chatController.newTopic();
                        },
                        size: 20.0,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  width: double.infinity,
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    contentPadding: const EdgeInsets.only(left: 12, top: 0, bottom: 0),
                    titleAlignment: ListTileTitleAlignment.top,
                    leading: const IconImage(
                      imagePath: 'assets/images/search.png',
                      onTap: null,
                      size: 18.0,
                    ),
                    title: TextField(
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: AppColors.lightGreyBackground,
                            height: 1.0,
                          ),
                      maxLines: 1,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(top: 0.0, right: 8.0, bottom: 24),
                        hintText: 'Search',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                    onTap: () {},
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                      child: CustomExpandable(
                    headerBuilder: (expanded, toggle) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: Icon(
                              expanded ? Icons.keyboard_arrow_down_outlined : Icons.keyboard_arrow_right,
                              size: 16,
                            ),
                            onPressed: toggle,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: InkWell(
                              onTap: toggle,
                              child: Text(
                                'Chats',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            icon: const Icon(
                              Icons.add,
                              size: 16,
                              color: AppColors.lightGreyIconColor,
                            ),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                    body: Obx(
                      () => ListView.separated(
                        itemCount: controller.topics.length,
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        separatorBuilder: (_, __) => const SizedBox(height: 6),
                        itemBuilder: (context, index) => Obx(
                          () => ChatTopic(
                            currentTopicId: controller.currentTopic.value.chatId,
                            topicModel: controller.topics[index],
                            onTap: () {
                              controller.topicEditId.value = '';
                              chatController.changeTopic(controller.topics[index]);
                            },
                            onItemPress: (value) {
                              if (value == 0) {
                                controller.chatTopicController.text = controller.topics[index].topic.toString();
                                chatController.showTopicEditDialog(
                                  controller.topics[index].chatId.toString(),
                                );
                              }
                              if (value == 1) {
                                chatController.deleteTopic(controller.topics[index].chatId!);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  )),
                ),
                Divider(
                  color: Colors.grey[800],
                  height: 0.1,
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: PopupMenuWidget(
                items: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
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
                    mainAxisSize: MainAxisSize.min,
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
                    mainAxisSize: MainAxisSize.min,
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
                offset: const Offset(0, -112),
                onSelected: (value) {
                  if (value == 2) {
                    controller.signOut();
                  }
                },
                child: Container(
                  color: AppColors.chatSideBarBackgroundColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 18,
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 15,
                        backgroundColor: Colors.blue,
                        child: Obx(
                          () => Text(
                            capitalizeFirstLetter(controller.email.value),
                            style: Theme.of(context).textTheme.bodyLarge!,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Obx(
                        () => Text(
                          controller.email.value,
                          style: Theme.of(context).textTheme.bodyLarge!,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
